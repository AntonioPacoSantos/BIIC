# BIIC
## Traductor de Godley Tables a archivos .mo (OpenModelica) 

Convenciones: 

1. Siempre, la primera fila, inicia con "Stock type", y cada columna puede ser "Asset", "Liability" o "Equity"
 
2. Siempre, la segunda fila, inicia con "Stock name"

3. Siempre, la tercera fila, inicia con "Starting Conditions"

4. No se puede dejar un espacio en blanco (para una posición ij, poner 0 si el Flow de la fila i no afecta al Stock de la columna j)

## Modelos basados en agentes 

- Hay dos modelos, ambos basados en el libro Economics with Heterogeneous Interacting Agents (Caiani et al.)

- El primero (toy model), corresponde al de la sección 2.1 y el segundo (Riccetti), al de la sección 2.2 

- Se agregan también simulaciones de montecarlo y un lotka-volterra de prueba

- Todos los modelos están implementados en OpenModelica (se recomienda tener, como mínimo, la versión v1.21.0) 

## Visualización 
 
- Implementación de visualización de la red de bancos y firmas del modelo Riccetti 

- Se hizo uso de la librería Manim de Python
