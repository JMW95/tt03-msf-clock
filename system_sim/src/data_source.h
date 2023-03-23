#pragma once

#include <cstdint>
#include <memory>
#include <string>
#include <vector>


class DataSource
{
public:
    static std::shared_ptr<DataSource> from_sim();
    static std::shared_ptr<DataSource> from_stdin();
    static std::shared_ptr<DataSource> from_file(std::string const& file);

    virtual ~DataSource() {};
    virtual bool next_sample() = 0;
    virtual bool done() const = 0;
};
