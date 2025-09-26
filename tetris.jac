"""Tetris Game in Jac with Gemini Integration"""

import random;
import from byllm.llm { Model }

glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);

"""Provide a fun comment after each action"""
def give_comment(action: str, score: int) -> str by llm();


node Board {
    has grid: list[list[int]] = [[0 for _ in range(10)] for _ in range(20)];
    has score: int = 0;
    has game_over: bool = False;
}


walker Tetris {
    has current_shape: list[list[int]];
    has row: int = 0;
    has col: int = 3;

    can start with root entry;
    can tick with step entry;
    can move_left with step entry;
    can move_right with step entry;
    can rotate with step entry;
}
