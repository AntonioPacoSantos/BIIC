__all__ = ['is_zero','delete_numbers','split_strings','remove_spaces_from_dict','is_not_digit']

def is_zero(value):
    """
    return wether a string is zero or not (including spaces)
    """
    value_str = str(value).replace(" ", "")
    return value_str != '0'


def delete_numbers(strings):
    """ 
    removes al digits inside a string
    """
    return ["".join(char for char in string if is_not_digit(char)) for string in strings]

def split_strings(string_list, symbol):
    """ 
    split string in two according to a symbol
    """
    res = []
    for string in string_list:
        splitting = string.split(symbol)
        if len(splitting) >= 2:
            for a in splitting: 
                if not (a.isspace() or len(a) == 0) : res.append(a)
        else: 
            res.append(splitting[0])
    return res

def remove_spaces_from_dict(dictionary):
    """ 
    remove all spaces from a dictionary 
    """
    new_dict = {}
    for key, value in dictionary.items():
        new_key = key.replace(" ", "")
        if isinstance(value, str):
            new_value = value.replace(" ", "")
        else:
            new_value = value
        new_dict[new_key] = new_value
    return new_dict


def is_not_digit(n):
    """
    test wether a given input is a digit or not
    """
    try:
        float(n)
        return False
    except ValueError:
        return  True
    