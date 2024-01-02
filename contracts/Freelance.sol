// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

//main contract for the freelance project.
//users can create services, view available services and hire a freelancer

contract FreelancePlatform {
    //declare public owner 
    address public owner;

    //service is on or off
    enum ServiceStatus {on, off}

    //service structure with fields
    struct Service {
        uint256 id;
        address payable provider;
        string title;
        string description;
        uint256 price;
        ServiceStatus status;
    }

    //we need a service list that holds the services list
    Service[] public services;
    uint256 public nextServiceId = 1;

    //mappings for each Provider and Buyer
    //each provider could have multiple "services" running
    mapping (uint256 => address) public serviceToProvider;
    mapping (address => uint256[]) public providerToServices;

    //each buyer could be purchasing multiple "services"
    mapping (uint256 => address) public jobToBuyer;
    mapping (address => uint256[]) public buyerToJobs; 

    //events that would be tiggered we need to track
    event ServiceCreated(uint256 serviceId, address indexed provider);
    event JobStarted(uint256 jobId, address indexed buyer);
    //technically a job is complete when the buyer says so. this why indexed buyer below
    event JobCompleted(uint256 jobId, address indexed buyer);

    //modifier helpers for security of public/external functions
    //require owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner.");
        _;
    }
    //require provider
    modifier onlyProvider(uint256 jobId) {
        require(msg.sender == serviceToProvider[jobId], "Not the provider.");
        _;
    }
    //check if its the service is available on or off
    modifier serviceIsAvailable(uint serviceId) {
        require(services[serviceId - 1].status == ServiceStatus.on, "Service not available.");
        _;
    }
    //check if sender is a buyer if jobId in mapping equals the sender
    modifier onlyBuyer(uint256 jobId) {
        require(msg.sender == jobToBuyer[jobId], "Not the buyer.");
        _;
    }

    //constructor to declare me as owner on deploy
    constructor() {
        owner = msg.sender;
    }

    //functions for our Freelance contract
    //we need these functions to interact with the blockchain
    //createService
    function createService(string memory title, string memory description, uint256 price) external {
        Service memory newService = Service({
            id: nextServiceId,
            provider: payable(msg.sender),
            title: title,
            description: description,
            price: price,
            status: ServiceStatus.on
        });
        //add new service to services list
        services.push(newService);
        //check that serviceId has the associated owner
        serviceToProvider[nextServiceId] = msg.sender;
        //add serviceId job to the owners list of services they provide
        providerToServices[msg.sender].push(nextServiceId);

        //run the event trigger with serviceId and address of the provider
        emit ServiceCreated(nextServiceId, msg.sender);

        //increment the nextServiceId for the next service to get new Id
        nextServiceId++;
    }
        //get list of available services
        function getServices() external view returns (Service[] memory) {
            return services;
        }

        //providers will need to accept the job to initiate the job process
        function acceptJob(uint jobId) external onlyProvider(jobId) serviceIsAvailable(jobId){
            jobToBuyer[jobId] = msg.sender;
            buyerToJobs[msg.sender].push(jobId);
            emit JobStarted(jobId, msg.sender);
        }

        //completeJob
        function completeJob(uint256 jobId) external onlyBuyer(jobId) {
            //additional logic needed
        }

        //cancelJob
        function cancelJob(uint256 jobId) external onlyBuyer(jobId) {
            //additional logic needed
        }
        
        //add more logic functions
}