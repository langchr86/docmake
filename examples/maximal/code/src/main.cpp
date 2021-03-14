#include <cstddef>

#include <iostream>
#include <string>

int main() {
    static constexpr size_t kColumnCount = 4;
    std::cout << "ASCII-Table" << std::endl;

    for (size_t i = 32; i < 128; ++i) {
        std::cout.width(3);
        std::cout.fill('0');
        std::cout << i << " = 0x";
        std::cout.setf(std::ios::hex, std::ios::basefield);
        std::cout.setf(std::ios::uppercase);
        std::cout << i << ": ";
        std::cout.unsetf(std::ios::hex);
        std::cout << static_cast<char>(i) << '\t';

        if (i % kColumnCount == kColumnCount - 1) {
            std::cout << std::endl;
        }
    }

    std::cout << std::endl;
    return 0;
}
