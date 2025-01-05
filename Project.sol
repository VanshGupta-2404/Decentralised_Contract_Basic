// SPDX-License-Identifier: GPL-3.0+
pragma solidity >=0.5.0 <0.9.0;

contract Project {
    struct Event {
        address admin;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketremaining;
    }

    mapping(uint => Event) public events;
    mapping(address => mapping(uint => uint)) public ticket;
    uint public nextId;


    function createEvent(string memory name, uint date, uint price, uint ticketCount) external {
        require(date > block.timestamp, "The event date must be in the future.");
        require(ticketCount > 0, "Number of tickets must be greater than zero.");

        events[nextId] = Event(msg.sender, name, date, price, ticketCount, ticketCount);
        nextId++;
    }

    // Buy tickets for an event
    function buyticket(uint id, uint quantity) external payable {
        require(events[id].date != 0, "The specified event does not exist.");
        require(events[id].date > block.timestamp, "The event has already occurred.");

        Event storage _event = events[id];
        require(msg.value == (_event.price * quantity), "Insufficient Ether provided.");
        require(_event.ticketremaining >= quantity, "Not enough tickets available.");

        _event.ticketremaining -= quantity;
        ticket[msg.sender][id] += quantity;
    }

    // Transfer tickets to another user
    function transferticket(uint id, uint quantity, address to) external payable {
        require(events[id].date != 0, "The specified event does not exist.");
        require(events[id].date > block.timestamp, "The event has already occurred.");

        address sender = msg.sender;
        require(ticket[sender][id] >= quantity, "You don't have enough tickets to transfer.");

        ticket[sender][id] -= quantity;
        ticket[to][id] += quantity;
    }
}
