#include <chrono>
#include <fstream>
#include <memory>
#include <string>
#include <thread>
#include <verilated.h>
#include "system.h"


using namespace std::chrono_literals;


static const char USAGE[] = "usage: system_sim [-h] [--inverted] [--trace] [--throttle] [data_source]";
static const char HELP[] =
    "Full system simulation\n"
    "\n"
    "positional arguments:\n"
    "    data_source  path to CSV file to use for input data, or '-' to use stdin\n"
    "\n"
    "optional arguments:\n"
    "    -h, --help   show this help message and exit\n"
    "    --inverted   input data is inverted\n"
    "    --trace      enable tracing and save to a '.gtkw' file\n"
    "    --throttle   throttle the data source to run in real time";


struct CommandLineArgs
{
    bool inverted = false;
    bool trace = false;
    bool throttle = false;
    std::shared_ptr<DataSource> data_source = DataSource::from_sim();
};


CommandLineArgs parse_args(int argc, char **argv)
{
    CommandLineArgs args;

    Verilated::commandArgs(argc, argv);

    for (int i = 1; i < argc; i++) {
        std::string arg = argv[i];

        if (arg.size() > 0 && arg[0] == '+') {
            // Arguments starting with '+' are for Verilator
        } else if (arg == "-h" || arg == "--help") {
            printf("%s\n\n%s\n", USAGE, HELP);
            std::exit(0);
        } else if (arg == "--inverted") {
            args.inverted = true;
        } else if (arg == "--trace") {
            args.trace = true;
        } else if (arg == "--throttle") {
            args.throttle = true;
        } else if (arg == "-") {
            args.data_source = DataSource::from_stdin();
        } else if (arg.size() > 0 && arg[0] == '-') {
            std::fprintf(stderr, "error: unrecognised option '%s'\n", arg.c_str());
            std::fprintf(stderr, "%s\n", USAGE);
            std::exit(1);
        } else {
            if (!std::ifstream{arg}.good()) {
                std::fprintf(stderr, "error: cannot open '%s'\n", arg.c_str());
                std::exit(1);
            }

            args.data_source = DataSource::from_file(arg);
        }
    }

    return args;
}


int main(int argc, char **argv)
{
    CommandLineArgs args = parse_args(argc, argv);

    System system{args.data_source, args.inverted};

    if (args.trace) {
        system.trace();
    }

    auto start_t = std::chrono::system_clock::now();

    while (!args.data_source->done()) {
        if (args.throttle) {
            std::this_thread::sleep_until(start_t + system.time_ns() * 1ns);
        }

        system.update();
    }

    return 0;
}
