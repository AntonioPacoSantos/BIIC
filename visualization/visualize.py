from manim import *
import networkx as nx  
from networkx.algorithms import bipartite
import pandas as pd 
    
N = 100
Z = 10 
ITERATIONS = 5
generic_path = '/tmp/OpenModelica_antonio/OMEdit/ABM_Riccetti.Riccetti_model/Riccetti_model_res.csv'
path_4 = '/home/antonio/BIIC/parser/csv/Riccetti_model_res_4.csv'
path_15 = 'csv/Riccetti_model_res_15.csv'
path_0_5 = 'csv/Riccetti_model_res_0-5.csv'


class NetworkScene(Scene):
    def animate_model(self, path):
        df = pd.read_csv(path, sep=',', header=0)
        bancos = [f'Banco{j}' for j in range(1, Z + 1)]
        firmas = [f'Firma{i}' for i in range(1, N + 1)]
        
        labels = {f'Firma{i}': i for i in range(1, N + 1)}
        labels.update({f'Banco{i}': i for i in range(1, Z + 1)})
        
        vertices = bancos + firmas
        new_edges = []
        old_edges = []
        to_be_removed_edges = []
        
        partitions = [bancos, firmas]
        
        vertex_config = {
            f'Firma{i}': {'fill_color': RED} for i in range(1, N + 1)
        }
        vertex_config.update({
            f'Banco{i}': {'fill_color': BLUE} for i in range(1, Z + 1)
        })
        
        edge_config = {
            'color': WHITE,
            'stroke_width': 0.5,
        }
        
        
        
        #G = Graph(vertices, new_edges, partitions=partitions, layout='spring', layout_scale=4,vertex_config=vertex_config)

        G = Graph(vertices, new_edges, partitions=partitions,layout='spring', layout_scale=3.5,vertex_config=vertex_config)
        
        self.add(G)
        self.play(Create(G))
        self.wait()
        num = 1
        it = 0
        
        while num < ITERATIONS*10:   
            text = Text("It " + str(it)).shift(UP).shift(LEFT*5)
            self.add(text)
            
            temporal_new_edges = []
            temporal_old_edges = []
            
            for i in range(1, N + 1):
                for j in range(1, Z + 1):
                    if any(x == 1 for x in df.loc[df['time'] == num, f'Phi[{j},{i}]'].values):
                        x = (f'Firma{i}', f'Banco{j}')
                        if x in old_edges or x in new_edges: 
                            temporal_old_edges.append(x)
                        else: 
                            temporal_new_edges.append(x)

            to_be_removed_edges = [x for x in (old_edges + new_edges) if x not in (temporal_new_edges + temporal_old_edges)]
            new_edges = temporal_new_edges 
            old_edges = temporal_old_edges            
            G.remove_edges(*to_be_removed_edges)    
            (G.add_edges(*new_edges))
            
            new = VGroup() 
            old = VGroup()
            for pair,line in G.edges.items():
                if pair in new_edges:
                    new.add(line)
            for pair,line in G.edges.items():
                if pair in old_edges:
                    old.add(line)
            new.set_color(YELLOW)
            old.set_color(WHITE)
                                                
            num += 10
            it += 1
            self.remove(text)

        
    def construct(self, path):
        self.animate_model(path)

class NetworkGeneric(NetworkScene):
    def construct(self):
        super().construct(generic_path)

class Network4(NetworkScene):
    def construct(self):
        super().construct(path_4)

class Network15(NetworkScene):
    def construct(self):
        super().construct(path_15)
        
        
class Network0_5(NetworkScene):
    def construct(self):
        super().construct(path_0_5)
        
        
class PointMovingOnShapes(Scene):
    def construct(self):
        circle = Circle(radius=1, color=BLUE)
        dot = Dot()
        dot2 = dot.copy().shift(RIGHT)
        self.add(dot)

        line = Line([3, 0, 0], [5, 0, 0])
        self.add(line)

        self.play(GrowFromCenter(circle))
        self.play(Transform(dot, dot2))
        self.play(MoveAlongPath(dot, circle), run_time=2, rate_func=linear)
        self.play(Rotating(dot, about_point=[2, 0, 0]), run_time=1.5)
        self.wait()