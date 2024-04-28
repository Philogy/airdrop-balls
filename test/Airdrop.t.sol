// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Airdrop} from "../src/Airdrop.sol";
import {MockERC20} from "./MockERC20.sol";

/// @author philogy <https://github.com/philogy>
contract AirdropTest is Test {
    Airdrop huff;

    function setUp() public {
        huff = Airdrop(_deployHuff());
        // huff = new Airdrop();
    }

    function test_airdropToMany() public {
        MockERC20 token = new MockERC20();
        address sender = makeAddr("sender");
        token.mint(sender, 1000e18);

        address[] memory friends = new address[](10);
        friends[0] = makeAddr("friend_0");
        friends[1] = makeAddr("friend_1");
        friends[2] = makeAddr("friend_2");
        friends[3] = makeAddr("friend_3");
        friends[4] = makeAddr("friend_4");
        friends[5] = makeAddr("friend_5");
        friends[6] = makeAddr("friend_6");
        friends[7] = makeAddr("friend_7");
        friends[8] = makeAddr("friend_8");
        friends[9] = makeAddr("friend_9");

        uint256[] memory amount = new uint256[](10);
        amount[0] = 3e18;
        amount[1] = 3e18;
        amount[2] = 3e18;
        amount[3] = 3e18;
        amount[4] = 3e18;
        amount[5] = 3e18;
        amount[6] = 3e18;
        amount[7] = 3e18;
        amount[8] = 3e18;
        amount[9] = 3e18;

        vm.startPrank(sender);
        token.approve(address(huff), type(uint256).max);
        vm.breakpoint("c");
        huff.airdropERC20(address(token), friends, amount, 30e18);
        vm.stopPrank();
    }

    function _deployHuff() internal returns (address airdrop) {
        string[] memory args = new string[](3);
        args[0] = "huffy";
        args[1] = "-b";
        args[2] = "src/Airdrop.huff";
        bytes memory initcode = vm.ffi(args);
        assembly ("memory-safe") {
            airdrop := create(0, add(initcode, 0x20), mload(initcode))
        }
    }
}
