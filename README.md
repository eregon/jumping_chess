# Artificial Intelligence for Jumping Chess

Jumping Chess, from a literal translation of 中國跳棋, also known as [Chinese checkers] or [Dames Chinoises], is an hexagonal board game where pawns get to jump
over other pawns, whether they are allies or opponents.

The rules are fairly simple, yet it requires some care for an efficient AI
as the branching factor (the number of moves possible from a given state)
is rather high.

There are 4 different player strategies:
* A `greedy` AI
* A `minimax` AI
* A `negamax` AI
* A `human` player

The search depth is configurable to adjust difficulty.

```
Usage:
$ bin/jumping_chess MAX_TURNS DEPTH_PLAYER1 STRATEGY_PLAYER1 STRATEGY_PLAYER2 DEPTH_PLAYER2
Such as
$ bin/jumping_chess 50 1 human negamax 3
```

The game is automatically saved under `log/`,
and can be resumed by passing the log file as the first argument.

[Chinese checkers]: https://en.wikipedia.org/wiki/Chinese_checkers
[Dames Chinoises]: https://fr.wikipedia.org/wiki/Dames_chinoises
