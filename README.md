# BIIC
Traductor de Godley Tables a archivos .mo (OpenModelica) 

Convenciones: 

1. Siempre, la primera fila, inicia con "Stock type", y cada columna puede ser "Asset", "Liability" o "Equity"
 
2. Siempre, la segunda fila, inicia con "Stock name"

3. Siempre, la tercera fila, inicia con "Starting Conditions"

4. No se puede dejar un espacio en blanco (para una posición ij, poner 0 si el Flow de la fila i no afecta al Stock de la columna j)
