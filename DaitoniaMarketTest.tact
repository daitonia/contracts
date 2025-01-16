// Tests for DaitoniaMarket Contract

import "DaitoniaMarket.tact";

contract DaitoniaMarketTest {
    DaitoniaMarket market;

    function beforeAll() public {
        market = new DaitoniaMarket();
    }

    function test_publish_agent() public {
        int public_key = 123;
        string picture_url = "http://example.com/pic.jpg";
        string title = "AI Agent";
        string description = "An AI agent for testing";
        string price_description = "10 tokens";
        int creator_public_key = 456;
        string[] keywords = ["AI", "agent", "test"];

        market.publish_agent(public_key, picture_url, title, description, price_description, creator_public_key, keywords);

        Agent agent = market.agents[public_key];
        assert(agent.public_key == public_key);
        assert(agent.picture_url == picture_url);
        assert(agent.title == title);
        assert(agent.description == description);
        assert(agent.price_description == price_description);
        assert(agent.creator_public_key == creator_public_key);
        assert(agent.keywords == keywords);
    }

    function test_create_request() public {
        int sender_public_key = 789;
        int agent_public_key = 123;
        string encrypted_text = "encrypted message";

        market.create_request(sender_public_key, agent_public_key, encrypted_text);

        int request_id = market.generate_request_id() - 1; // Assuming request_id is generated based on timestamp
        Request request = market.requests[request_id];
        assert(request.sender_public_key == sender_public_key);
        assert(request.agent_public_key == agent_public_key);
        assert(request.encrypted_text == encrypted_text);
        assert(request.price == 0);
        assert(request.status == 0);
    }

    function test_respond_to_request() public {
        int request_id = 1;
        int price = 100;

        market.respond_to_request(request_id, price);

        Request request = market.requests[request_id];
        assert(request.price == price);
        assert(request.status == 1);
    }

    function test_accept_request() public {
        int request_id = 1;

        market.accept_request(request_id);

        Request request = market.requests[request_id];
        assert(request.status == 2);
    }

    function test_reject_request() public {
        int request_id = 1;

        market.reject_request(request_id);

        Request request = market.requests[request_id];
        assert(request.status == 3);
    }
}
