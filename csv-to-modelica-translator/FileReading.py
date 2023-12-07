import pandas as pd  
from abc import ABC, abstractmethod

class Flow: 
    def __init__(self,name,value): 
        self.name = name 
        self.value = value  


class FileReading(ABC):
    
    def __init__(self,filename):
        self.filename = filename
        
    @abstractmethod
    def create_dictionary_from_file(self): 
        """
        reads a file and creates a dictionary
        """
        ...
        
    def transform_to_flows_dictionary(self,dictionaryFromFile):
        """ 
        transform a nested dictionary into a dictionary of flow-type elements
        """
        for stock_type in dictionaryFromFile.keys(): 
            for stock in dictionaryFromFile[stock_type].keys():
                dictionaryFromFile[stock_type][stock] = [Flow(k, v) for k, v in dictionaryFromFile[stock_type][stock].items()]

    def conversion_to_dataframe(self):
        """ 
        read a file and return three dicionaries of stocks, one for each possible type
        """
        dictionaryFromCSV = self.create_dictionary_from_file()
        self.transform_to_flows_dictionary(dictionaryFromCSV)
            
        #separating the dictionary into three, one for each stock type
        assets = dictionaryFromCSV['Asset'] if 'Asset' in dictionaryFromCSV else {}
        liabilities = dictionaryFromCSV['Liability'] if 'Liability' in dictionaryFromCSV else {}    
        equity = dictionaryFromCSV['Equity'] if 'Equity' in dictionaryFromCSV else {}
    
        return assets,liabilities,equity

class TxtReading(FileReading):
    def create_dictionary_from_file(self):
        dataFrame = pd.read_csv('files/txt/' + self.filename + '.txt', sep=",", header=[0,1], index_col=0)
        dataFrame = dataFrame.transpose() 
        dictionaryFromCSV = {level: dataFrame.xs(level).to_dict('index') for level in dataFrame.index.levels[0]}
        return dictionaryFromCSV

class OdsReading(FileReading):
    def create_dictionary_from_file(self):
        dataFrame = pd.read_excel('files/ods/' + self.filename + '.ods', header=[0,1], index_col=0)
        dataFrame = dataFrame.transpose() 
        dictionaryFromCSV = {level: dataFrame.xs(level).to_dict('index') for level in dataFrame.index.levels[0]}
        return dictionaryFromCSV

class XlsxReading(FileReading):
    def create_dictionary_from_file(self):
        dataFrame = pd.read_excel('files/xlsx/' + self.filename + '.xlsx', header=[0,1], index_col=0)
        dataFrame = dataFrame.transpose() 
        dictionaryFromCSV = {level: dataFrame.xs(level).to_dict('index') for level in dataFrame.index.levels[0]}
        return dictionaryFromCSV
        