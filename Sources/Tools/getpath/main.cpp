/**
 * @file xpro.getpath
 * 
 * @brief returns full path
 * 
 * @author Brando (BrandonMFong.com)
 */

#include <xPro/xPro.hpp>

xBegin

    xDirectory * pathObject;
    if(argc != 2)
    {
        std::cout   
            << "Usage: getpath <arg>"
            << "    <arg>   Relative or real full path" 
            << 
        std::endl;
    } 
    pathObject = new xDirectory(argv[1]);
    std::cout << pathObject->Path() << std::endl;

xEnd 