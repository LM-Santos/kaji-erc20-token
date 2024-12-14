// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract KajiToken {
    string constant TOKEN_NAME = "Kajicoin";
    string constant TOKEN_SYMBOL = "KAJI";

    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    /* Returns the name of the token. */
    function name() public pure returns (string memory) {
        return TOKEN_NAME;
    }

    /* Returns the symbol of the token. */
    function symbol() public pure returns (string memory) {
        return TOKEN_SYMBOL;
    }

    /* Returns the number of decimals the token uses - e.g. 8, means to divide the token amount by 100000000 
    to get its user representation.

    OPTIONAL - This method can be used to improve usability, but interfaces and other contracts MUST NOT 
    expect these values to be present.*/
    function decimals() public pure returns (uint8) {
        return 8;
    }

    // Returns the total token supply.
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /* Returns the account balance of another account with address _owner.*/
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /* Transfers _value amount of tokens to address _to, and MUST fire the Transfer event.
    The function SHOULD throw if the message caller’s account balance does not have enough tokens to spend.
    Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.*/
    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[msg.sender] >= amount, "ERC20: transfer amount exceeds balance");

        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    /* Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.

    The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your 
    behalf. This can be used for example to allow a contract to transfer tokens on your behalf and/or to 
    charge fees in sub-currencies. The function SHOULD throw unless the _from account has deliberately 
    authorized the sender of the message via some mechanism.
    
    Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.*/
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
        require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        _allowances[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    /* Allows _spender to withdraw from your account multiple times, up to the _value amount. 
    If this function is called again it overwrites the current allowance with _value.

    To prevent attack vectors like the one described here and discussed here, clients SHOULD 
    make sure to create user interfaces in such a way that they set the allowance first to 0 
    before setting it to another value for the same spender. 
    THOUGH The contract itself shouldn’t enforce it, to allow backwards compatibility with contracts
    deployed before */
    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /* Returns the amount which _spender is still allowed to withdraw from _owner. */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /* MUST trigger when tokens are transferred, including zero value transfers.
    A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address 
    set to 0x0 when tokens are created. */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /* MUST trigger on any successful call to approve(address _spender, uint256 _value). */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}