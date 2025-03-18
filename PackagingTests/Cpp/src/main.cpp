#include "CSP/CSPFoundation.h"
#include <iostream>


int main(){
    csp::CSPFoundation::Initialise("https://ogs.magnopus-stg.cloud", "CSP_HELLO_WORLD");
    std::cout << "Initialized Foundation." << std::endl;
}
