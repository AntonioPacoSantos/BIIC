from aux_func import *
from FileReading import Flow 

OPERATIONS_DEFINER = ['/','*','+','-']

def filtering_conditions(transaction): 
    return (is_zero(transaction.value) or transaction.name == 'Initial Conditions')

def filtering_flows(stock_type, variables):
    """
    removes all zero transactions from stock_type and extracts all posible variables 
    """
    for stock in stock_type.keys(): 
        stock_type[stock] = list(filter(lambda transaction : filtering_conditions(transaction), stock_type[stock]))
        variables.extend([element.value for element in stock_type[stock]])
    
    return stock_type,variables

def filtering_variables(variables):
    """
    takes a list and exctracts variables for modelica
    """
    variables = list(filter(is_not_digit,variables))
    variables = delete_numbers(variables)
    for operation in OPERATIONS_DEFINER:
       variables = split_strings(variables,operation)
    variables = list(map(lambda variable: variable.strip(),variables))
    
    variables = [*set(variables)]
    return variables


def apply_filter(assets,liabilities,equity): 
    """
    takes assets,liabilities and equity, applies all the correct filtering and exctracts the variables for modelica
    """
    variables = []
    assets,variables = filtering_flows(assets, variables)
    liabilities,variables = filtering_flows(liabilities,variables)
    equity, variables = filtering_flows(equity,variables)
    
    variables = filtering_variables(variables)
    
    return assets,liabilities,equity,variables


