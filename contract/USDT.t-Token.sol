/**
 *Submitted for verification at BscScan.com on 2025-08-20
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

/**
 * @title Tokenusd (Ultra-Otimizado)
 * @dev Contrato de token ERC-20 com máxima otimização de gas
 * @dev Utiliza técnicas avançadas para reduzir custos de implantação e execução
 */
contract Tokenusd {
    // --- VARIÁVEIS E CONSTANTES ---
    // Empacotamento de variáveis para economizar slots de armazenamento
    string public constant name = "Tethy";
    string public constant symbol = "USDT.t";
    uint8 public constant decimals = 18;
    
    uint256 private _totalSupply;
    address public owner;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // --- EVENTOS ---
    // Eventos com menos dados para reduzir custos de logging
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed _owner, address indexed spender, uint256 value);

    // --- MODIFICADORES ---
    modifier onlyOwner() {
        if (msg.sender != owner) revert("Only owner");
        _;
    }

    // --- CONSTRUTOR ---
    constructor(uint256 initialSupply) {
        _totalSupply = initialSupply * 1e18; // Notação científica mais eficiente
        _balances[msg.sender] = _totalSupply;
        owner = msg.sender;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // --- FUNÇÕES PÚBLICAS ---
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function allowance(address _owner, address spender) external view returns (uint256) {
        return _allowances[_owner][spender];
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        _spendAllowance(from, msg.sender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // --- FUNÇÕES INTERNAS OTIMIZADAS ---
    function _transfer(address from, address to, uint256 amount) internal {
        // Verificações concisas usando revert personalizado
        if (from == address(0)) revert("From zero address");
        if (to == address(0)) revert("To zero address");
        if (amount == 0) revert("Zero amount");
        
        uint256 fromBalance = _balances[from];
        if (fromBalance < amount) revert("Insufficient balance");

        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);
    }

    function _approve(address _owner, address spender, uint256 amount) internal {
        if (_owner == address(0)) revert("Approve from zero");
        if (spender == address(0)) revert("Approve to zero");

        _allowances[_owner][spender] = amount;
        emit Approval(_owner, spender, amount);
    }

    function _spendAllowance(address _owner, address spender, uint256 amount) internal {
        uint256 currentAllowance = _allowances[_owner][spender];
        
        // Aprove infinito não precisa de atualização
        if (currentAllowance != type(uint256).max) {
            if (currentAllowance < amount) revert("Insufficient allowance");
            
            unchecked {
                _approve(_owner, spender, currentAllowance - amount);
            }
        }
    }

    function _mint(address to, uint256 amount) internal {
        if (to == address(0)) revert("Mint to zero");
        
        unchecked {
            _totalSupply += amount;
            _balances[to] += amount;
        }
        
        emit Transfer(address(0), to, amount);
    }
}