import asyncio
import logging
import struct
import time
import numpy as np
import typing as t

import websockets

host = "thescotts.ddns.net"
port = 8073


async def amain():
    ping_task = None
    sample_rate = 12000

    async def do_ping(ws):
        try:
            while True:
                await asyncio.sleep(10)
                await ws.send("SET keepalive")
        except asyncio.CancelledError:
            pass

    async def handle_msg_param(name: str, value: t.Optional[str], ws):
        nonlocal sample_rate
        if name == "audio_rate":
            assert value is not None
            sample_rate = int(value)
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

    async def handle_snd(body: bytes, ws):
        flags, seq = struct.unpack('<BI', body[0:5])
        smeter = struct.unpack('>H', body[5:7])[0]
        data = body[7:]
        samples = np.frombuffer(data, dtype=">h").astype(np.int16)

        # TODO do something with the samples


    async def handle(msg: t.Union[bytes, str], ws):
        tag = msg[0:3]
        if isinstance(tag, bytes):
            tag = tag.decode("utf-8")

        if tag == "MSG":
            await handle_msg(msg[4:], ws)
        elif tag == "SND":
            assert isinstance(msg, bytes)
            await handle_snd(msg[3:], ws)

    try:
        async with websockets.connect(f"ws://{host}:{port}/kiwi/{int(time.time())}/SND", close_timeout=0) as ws:
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
