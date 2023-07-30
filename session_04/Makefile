deploy:
	forge script script/Token.s.sol:TokenScript --fork-url http://localhost:8545 --private-key $PRIVATE_KEY --broadcast
owner:
	cast call $CONTRACT_ADDRESS "owner()"