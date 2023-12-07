import networkx as nx
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import random 
import pandas as pd  


df = pd.read_csv('/tmp/OpenModelica_antonio/OMEdit/ABM_Riccetti.Riccetti_model/Riccetti_model_res.csv', sep=',',header=0)
N = 20
Z = 2
G = nx.Graph()
# Create an empty graph
firms = []
def draw_nodes(): 
    for i in range(1,N+1): 
        G.add_node('Firma'+str(i))
        firms.append('Firma'+str(i))
    for j in range(1,Z+1): 
        G.add_node('Banco'+str(j))
    
colors = ['red']*N + ['blue']*Z

# Initialize the plot
fig, ax = plt.subplots()
pos = nx.bipartite_layout(G,firms)  # Layout for the initial graph
nodes = nx.draw_networkx_nodes(G, pos)
edges = nx.draw_networkx_edges(G, pos)
labels = nx.draw_networkx_labels(G, pos)

# Function to update the graph at each time step
def update(num):
    ax.clear()
    # At each time step, add a new node to the graph
    draw_nodes()
    for i in range(1,N+1): 
        for j in range(1,Z+1): 
            if any(x == 1 for x in df.loc[df['time'] == num,'Phi['+ str(j) + ','+str(i) + ']'].values):
                G.add_edge('Firma'+str(i),'Banco'+str(j), color = 'green')
                
        
    pos = nx.bipartite_layout(G,firms) 
    nx.draw_networkx_nodes(G, pos, node_color = colors)
    nx.draw_networkx_edges(G, pos)
    nx.draw_networkx_labels(G, pos)
    G.clear_edges()

    # Optionally, you can add edges or modify the graph as needed at each step

    ax.set_title(f'Time Step: {num}')

# Create the animation
ani = animation.FuncAnimation(fig, update, frames=range(1, 100), repeat=False, interval=50)

plt.show()