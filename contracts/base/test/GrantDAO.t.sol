// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/GrantDAO.sol";

contract GrantDAOTest is Test {
    GrantDAO public c;
    
    function setUp() public {
        c = new GrantDAO();
    }

    function testDeployment() public {
        assertTrue(address(c) != address(0));
    }
}
