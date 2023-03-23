#include <fstream>
#include <iostream>
#include "data_source.h"


class DumbDataSource : public DataSource
{
public:
    bool next_sample() override;
    bool done() const override;

private:
    uint64_t m_idx = 0;
};


bool DumbDataSource::next_sample()
{
    return (m_idx++ % 1000) > 100;
}


bool DumbDataSource::done() const
{
    return false;
}


class FileDataSource : public DataSource
{
public:
    explicit FileDataSource(std::string const& path);
    bool next_sample() override;
    bool done() const override;

private:
    size_t m_idx = 0;
    std::vector<uint8_t> m_samples;
};


FileDataSource::FileDataSource(std::string const& path)
{
    std::ifstream f{path};

    if (!f) {
        std::fprintf(stderr, "ERROR: Failed to open file %s\n", path.c_str());
        std::exit(1);
    }

    std::string line;
    while (std::getline(f, line)) {
        try {
            m_samples.push_back(std::stoi(line));
        } catch(std::exception const&) {
            std::fprintf(stderr, "ERROR: Failed to parse line\n");
            std::exit(1);
        }
    }
}


bool FileDataSource::next_sample()
{
    return done() ? 0 : m_samples[m_idx++];
}


bool FileDataSource::done() const
{
    return m_idx >= m_samples.size();
}


class StdinDataSource : public DataSource
{
public:
    bool next_sample() override;
    bool done() const override;
};


bool StdinDataSource::next_sample()
{
    std::string line;
    std::getline(std::cin, line);

    try {
        int val = std::stoi(line);
        return val == 1;
    } catch(std::exception const&) {
        std::fprintf(stderr, "ERROR: Failed to parse sample\n");
        std::exit(1);
    }
}

bool StdinDataSource::done() const
{
    return false;
}


std::shared_ptr<DataSource> DataSource::from_sim()
{
    return std::make_shared<DumbDataSource>();
}


std::shared_ptr<DataSource> DataSource::from_stdin()
{
    return std::make_shared<StdinDataSource>();
}


std::shared_ptr<DataSource> DataSource::from_file(std::string const& file)
{
    return std::make_shared<FileDataSource>(file);
}
