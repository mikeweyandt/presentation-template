---
marp: true
theme: akron-cs
paginate: true
size: 16:9
title: Graphs and Shortest Paths
author: Your Name
header: '~/cs-501/lecture-04'
footer: 'CS 501 · The University of Akron'
---

<!-- _class: title -->
<!-- _paginate: false -->
<!-- _header: '' -->
<!-- _footer: '' -->

# Graphs & Shortest Paths

## Dijkstra, Bellman–Ford, and why the difference matters

Your Name · Department of Computer Science<br>The University of Akron

---

## Agenda

- Model the problem as a weighted graph
- Walk Dijkstra's algorithm line by line
- Prove why it needs non-negative weights
- Measure it, then pick the right tool

> One idea per slide. If a slide needs a scrollbar, it needs to be two slides.

---

<!-- _class: divider -->

### 01

# Modeling

The graph is the hard part; the algorithm is the easy part.

---

## From map to graph

### Definitions

A weighted digraph is a pair $G = (V, E)$ with a weight function
$w : E \rightarrow \mathbb{R}$.

- **Vertices** are the places you can be
- **Edges** are the moves you can make
- **Weight** is whatever you are minimizing — time, cost, latency

The shortest path from $s$ to $v$ is written $\delta(s, v)$:

$$ \delta(s,v) = \min \{\, w(p) \;:\; p \text{ is a path } s \rightsquigarrow v \,\} $$

---

## Two representations

<div class="columns">
<div>

### Adjacency list

- Space <span class="big-o">O(V + E)</span>
- Iterating a vertex's edges is fast
- The right default for sparse graphs

</div>
<div>

### Adjacency matrix

- Space <span class="big-o">O(V²)</span>
- Edge lookup is constant time
- Only worth it when $E \approx V^2$

</div>
</div>

Real road and social networks are sparse, so **adjacency list unless proven otherwise**.

---

## The relaxation step

<div class="diagram">
<div class="node">s</div>
<span class="arrow"></span>
<div class="node accent">u</div>
<span class="arrow"></span>
<div class="node">v</div>
<span class="edge">&nbsp;&nbsp;w(u,v) = 7</span>
</div>

Every shortest-path algorithm is the same one move applied in a different order:

```python
def relax(u, v, w, dist, prev):
    if dist[u] + w[u, v] < dist[v]:
        dist[v] = dist[u] + w[u, v]
        prev[v] = u
        return True
    return False
```

Dijkstra picks the order greedily. Bellman–Ford brute-forces it.

---

<!-- _class: divider -->

### 02

# The algorithm

---

<div class="algo" data-name="Dijkstra(G, w, s)" data-cost="O(E log V)">

1. `for each` v `in` V: dist[v] ← ∞, prev[v] ← nil
2. dist[s] ← 0
3. Q ← min-priority queue keyed by dist, holding all of V
4. `while` Q is not empty:
5. u ← Extract-Min(Q)
6. `for each` edge (u, v) `in` Adj[u]:
7. `if` dist[u] + w(u,v) < dist[v]:
8. dist[v] ← dist[u] + w(u,v), prev[v] ← u
9. Decrease-Key(Q, v)

</div>

Line 5 is the greedy choice, and line 9 is the one everybody forgets.

---

<!-- _class: code -->

## In practice

<div class="code-card" data-file="dijkstra.py">

```python
import heapq
from math import inf

def dijkstra(graph: dict, source: str) -> dict:
    """Single-source shortest paths. Requires non-negative weights."""
    dist = {v: inf for v in graph}
    dist[source] = 0
    seen, queue = set(), [(0, source)]

    while queue:
        d, u = heapq.heappop(queue)
        if u in seen:          # stale entry — lazy deletion
            continue
        seen.add(u)
        for v, weight in graph[u].items():
            if d + weight < dist[v]:
                dist[v] = d + weight
                heapq.heappush(queue, (dist[v], v))
    return dist
```

</div>

---

<!-- _class: terminal -->

## Measuring it

<div class="terminal" data-title="bash">

```console
$ python -m timeit -s "from bench import g, dijkstra" "dijkstra(g, 'a')"
20 loops, best of 5: 11.4 msec per loop
$ python bench.py --vertices 50000 --edges 200000 --compare
dijkstra       0.42s   visited 50000 vertices
bellman-ford  18.71s   visited 50000 vertices  (44x slower)
```

</div>

Always measure on a graph the shape of your real one. Dijkstra's advantage
comes from sparsity, and a dense benchmark will hide it.

---

## Why non-negative weights?

> **Claim.** When Dijkstra removes $u$ from the queue, $dist[u] = \delta(s,u)$.

The greedy choice assumes that extending a path can never make it shorter. With a
negative edge that assumption fails, and a vertex finalized early may still be wrong.

$$ w(u,v) < 0 \;\Longrightarrow\; \delta(s,v) < \delta(s,u) \text{ is possible after } u \text{ is settled} $$

> **Use Bellman–Ford instead.** It relaxes every edge $|V|-1$ times, so it tolerates
> negative weights and detects negative cycles — at <span class="big-o">O(V · E)</span>.

---

## Picking the right one

| Algorithm      | Weights        | Time              | Use when                   |
| -------------- | -------------- | ----------------- | -------------------------- |
| BFS            | unweighted     | `O(V + E)`        | every edge costs the same  |
| Dijkstra       | non-negative   | `O(E log V)`      | the common case            |
| Bellman–Ford   | any            | `O(V · E)`        | negative edges possible    |
| Floyd–Warshall | any            | `O(V³)`           | you need *all* pairs       |

Round aggressively and cite the source — precision the back row cannot read is wasted.

---

<!-- _class: end -->
<!-- _paginate: false -->
<!-- _header: '' -->
<!-- _footer: '' -->

# Questions?

**Your Name**

your.email@uakron.edu · [uakron.edu](https://www.uakron.edu)
