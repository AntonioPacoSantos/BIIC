from FileReading import Flow
from abc import ABC,abstractmethod 
from os import system
import copy

class Translator(ABC):
    
    @abstractmethod
    def __init__(self,assets: dict, liabilities: dict, equity:dict, variables:list, filename):
        self.assets = copy.copy(assets) 
        self.liabilities = copy.copy(liabilities)
        self.equity = copy.copy(equity)
        self.variables = copy.copy(variables) 
        self.file = filename
    
    @abstractmethod
    def write_starting_conditions_outputs(cls,stock_type):
        """
        write the starting values of outputs of a given type in a modelica file
        """
        ...
        
    @abstractmethod
    def write_starting_conditions_inputs(cls,variables):
        """
        write the starting values of inputs in a modelica file
        """
        ...
    
    def write_equations_for_output(self,stock_type):
        """ 
        write equations for the outputs of a given type in a modelica file
        """
        for output_name in stock_type.keys(): 
            derivative = '('+ ') + ('.join(str(flow.value) for flow in (stock_type[output_name])) + '); \n'
            if stock_type[output_name] == []: 
                self.file.write(f'der({output_name}) = 0;\n')
            else: 
                self.file.write(f'der({output_name}) = {derivative}')
                
    @abstractmethod
    def modelica_parsing(cls): 
        """ 
        generate a modelica file with a godley table
        """
        ...
        

class RegularTranslator(Translator): 
    
    def __init__(self,assets: dict, liabilities: dict, equity:dict, variables:list, filename): 
        super().__init__(assets, liabilities, equity, variables, filename)
        modelica_file = open('files/modelica/' + filename + '.mo','w')
        self.file = modelica_file
        self.filename = filename
        
    def write_starting_conditions_outputs(self,stock_type):
        for output_name in stock_type.keys(): 
            (self.file).write(f'output Real {output_name}(start = {stock_type[output_name][0].value});\n')
            stock_type[output_name].pop(0)

    def write_starting_conditions_inputs(self):
        for variable in self.variables: 
            self.file.write(f'input Real {variable};\n')

    
    def modelica_parsing(self): 
        self.file.write('model Godley_table \n')

        self.write_starting_conditions_outputs(self.assets)
        self.write_starting_conditions_outputs(self.liabilities)
        self.write_starting_conditions_outputs(self.equity)
        self.write_starting_conditions_inputs()
        
        self.file.write('equation \n')
        
        self.write_equations_for_output(self.assets)
        self.write_equations_for_output(self.liabilities)
        self.write_equations_for_output(self.equity)
    
        self.file.write('end Godley_table; \n')
        


class ConnectorTranslator(Translator): 
    
    def __init__(self,assets: dict, liabilities: dict, equity:dict, variables:list, filename): 
        super().__init__(assets, liabilities, equity, variables, filename)
        modelica_file = open('files/modelica/' + filename +'_block_'+ '.mo','w')
        self.file = modelica_file
        self.filename = filename
        
    def write_starting_conditions_outputs(self,stock_type):
        for output_name in stock_type.keys(): 
            self.file.write(f'Modelica.Blocks.Interfaces.RealOutput {output_name}(start = {stock_type[output_name][0].value});\n')
            stock_type[output_name].pop(0)

    def write_starting_conditions_inputs(self):
        for variable in self.variables: 
            self.file.write(f'Modelica.Blocks.Interfaces.RealInput {variable};\n')

    
    def modelica_parsing(self): 
        self.file.write('model Connected_Godley_table \n')

        self.write_starting_conditions_outputs(self.assets)
        self.write_starting_conditions_outputs(self.liabilities)
        self.write_starting_conditions_outputs(self.equity)
        self.write_starting_conditions_inputs()
        
        self.file.write('equation \n')
        
        self.write_equations_for_output(self.assets)
        self.write_equations_for_output(self.liabilities)
        self.write_equations_for_output(self.equity)
    
        self.file.write('end Connected_Godley_table; \n')



        
    