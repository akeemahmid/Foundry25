// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/Deployment.s.sol";
import {FundfundMe} from "../../script/Interaction.s.sol";

contract TestFund is Test {
    FundMe fundMe;
    // this makeAddr user in the user we will be using for all our transaction
    address USER = makeAddr("user");
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        // set up is the first thing that will run in forge test

        // fundme = new FundMe();
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanWidthdraw() public {
        // FundfundMe fundFundme = new FundfundMe();
        // fundFundme.fundFundMe(address(fundMe));

        // address funders = fundMe.getFunder(1);
        // // vm.expectRevert();
        // assertEq(funders, USER);

        vm.prank(USER); // Make USER the sender
        fundMe.fund{value: 1 ether}(); // Send some ETH to fundMe

        address funder = fundMe.getFunder(0); // index should be 0, not 1
        assertEq(funder, USER);
    }
}
