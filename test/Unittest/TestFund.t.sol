// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/Deployment.s.sol";

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

    function testMinimumUsd() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testFundsFailWithoutENoughEth() public {
        // here we are expecting the next function to be a wrong function so it can pass through
        vm.expectRevert();
        fundMe.fund();
    }

    function testUpdatedStructure() public funded {
        // this is to like initialize the user i create from makeaddr earlier

        // vm.prank(USER); //this is a cheatcode

        // // here i fund this account with 10eth
        // fundMe.fund{value: 10e18}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);

        // i  want you to get the address and check if i truly fund it with 10 ether

        assertEq(amountFunded, 10e18);
    }

    function testAddFundersToArrayOfFunders() public funded {
        // getfunder is a function from the fundme contract that return an address
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        // i dont really get this part
        fundMe.withdraw();
    }

    modifier funded() {
        // this is a modifier so everybody can carry it name will sahre it function
        vm.prank(USER);
        fundMe.fund{value: 10e18}();
        _;
    }

    function testWithdrawWithASingleFunder() public funded {
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawWithASingleFunderCheaper() public funded {
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.cheaperWidthdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance
        );
    }
}
