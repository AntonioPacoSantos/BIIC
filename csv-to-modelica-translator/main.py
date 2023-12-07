from filtering import apply_filter
from FileReading import TxtReading,OdsReading,XlsxReading
from os import system
from Translation import RegularTranslator,ConnectorTranslator

if __name__== '__main__':     
    print('Ingrese el formato del archivo (o para .ods, t para .txt, x para .xlsx)')
    filetype = input()
    assets,liabilities,equity,variables = {},{},{},[]
    
    filename = ''
    
    if filetype == 'o':
        print('Ingrese el nombre del archivo ods:')
        filename = input() 
        fileReader = OdsReading(filename=filename)
        assets,liabilities,equity,variables= apply_filter(*fileReader.conversion_to_dataframe())
    
    if filetype == 't':
        print('Ingrese el nombre del archivo txt:')
        filename = input() 
        fileReader = TxtReading(filename=filename)
        assets,liabilities,equity,variables= apply_filter(*fileReader.conversion_to_dataframe())
        
    if filetype == 'x':
        print('Ingrese el nombre del archivo xlsx:')
        filename = input() 
        fileReader = XlsxReading(filename=filename)
        assets,liabilities,equity,variables= apply_filter(*fileReader.conversion_to_dataframe())
        
    print('¿Desea utilizar connectors? (y/n)')
    version = input()
    
    if version == 'y': 
        ConnectorTranslator(assets,liabilities,equity,variables,filename).modelica_parsing()
        print('El script de modelica es el siguiente:')
        system(f"cat files/modelica/{filename}" + "_block_.mo")

    else: 
        RegularTranslator(assets,liabilities,equity,variables,filename).modelica_parsing()
        system(f"cat files/modelica/{filename}.mo") 
    
    
    