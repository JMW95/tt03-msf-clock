import asyncio
import logging
import struct
import time
import typing as t

import numpy as np
import scipy
import websockets

host = "thescotts.ddns.net"
port = 8073


async def amain():
    ping_task = None
    sample_rate = 12000

    # Low pass filter
    filter_len_s = 0.04
    filter_len_samples = round(filter_len_s * sample_rate)
    taps = np.ones(filter_len_samples)/filter_len_samples

    # Sample buffer
    sample_buf = np.ndarray((0,), dtype=np.int16)
    agc_window = np.ndarray((0,), dtype=np.int16)

    async def do_ping(ws):
        try:
            while True:
                await asyncio.sleep(5)
                await ws.send("SET keepalive")
        except asyncio.CancelledError:
            pass

    async def handle_msg_param(name: str, value: t.Optional[str], ws):
        nonlocal sample_rate, filter_len_samples, taps
        if name == "audio_rate":
            assert value is not None
            sample_rate = int(value)
            filter_len_samples = round(filter_len_s * sample_rate)
            taps = np.ones(filter_len_samples)/filter_len_samples
            await ws.send(f"SET AR OK in={value} out=44100")
        elif name == "sample_rate":
            await ws.send("SET squelch=0 max=0")
            await ws.send("SET genattn=0")
            await ws.send("SET gen=0 mix=0")
            await ws.send("SET mod=cwn low_cut=470 high_cut=530 freq=59.500")
            await ws.send("SET agc=0 hang=0 thresh=0 slope=0 decay=0 manGain=0")
            await ws.send("SET compression=0")

    async def handle_msg(body: t.Union[bytes, str], ws):
        if isinstance(body, bytes):
            body = body.decode("utf-8")

        for pair in body.split(" "):
            if "=" in pair:
                name, value = pair.split("=", 1)
                await handle_msg_param(name, value, ws)
            else:
                name = pair
                await handle_msg_param(name, None, ws)

    def handle_snd(body: bytes):
        nonlocal sample_buf, agc_window

        flags, seq = struct.unpack('<BI', body[0:5])
        smeter = struct.unpack('>H', body[5:7])[0]
        data = body[7:]

        chunk = np.frombuffer(data, dtype=">h").astype(np.int16)

        # Extract envelope
        envelope = np.abs(scipy.signal.hilbert(chunk))

        sample_buf = np.concatenate((sample_buf, envelope))
        if sample_buf.shape[0] < 1024:
            return

        filtered = scipy.signal.lfilter(taps, 1, sample_buf)[512:1024]
        sample_buf = sample_buf[512:]

        agc_window = np.concatenate((agc_window, filtered))
        if agc_window.shape[0] > 30000:
            agc_window = agc_window[512:30000]

        # Threshold
        threshold = (np.percentile(agc_window, 95) + np.percentile(agc_window, 5)) / 2
        digitised = (filtered > threshold).astype(int)

        # Resample
        rate = sample_rate / 1000
        idxs = np.arange(0, len(digitised), rate).astype(int)
        digitised = digitised[idxs]

        for s in digitised:
            print(s)


    async def handle(msg: t.Union[bytes, str], ws):
        tag = msg[0:3]
        if isinstance(tag, bytes):
            tag = tag.decode("utf-8")

        if tag == "MSG":
            await handle_msg(msg[4:], ws)
        elif tag == "SND":
            assert isinstance(msg, bytes)
            handle_snd(msg[3:])

    try:
        async with websockets.connect(f"ws://{host}:{port}/kiwi/{int(time.time())}/SND", close_timeout=0, ping_interval=None) as ws:
            ping_task = asyncio.create_task(do_ping(ws))
            await ws.send("SET auth t=kiwi p=#")

            while True:
                msg = await ws.recv()
                await handle(msg, ws)
    except Exception:
        logging.exception("Exception in main loop")
    finally:
        if ping_task:
            ping_task.cancel()
            await ping_task


def main():
    logging.basicConfig(level=logging.WARN)
    asyncio.run(amain())


if __name__ == "__main__":
    main()
