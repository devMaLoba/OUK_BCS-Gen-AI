import random;

const SHAPES = [
    [[1, 1, 1, 1]],                  # I
    [[1, 1], [1, 1]],                # O
    [[0, 1, 0], [1, 1, 1]],          # T
    [[1, 1, 0], [0, 1, 1]],          # S
    [[0, 1, 1], [1, 1, 0]],          # Z
    [[1, 0, 0], [1, 1, 1]],          # J
    [[0, 0, 1], [1, 1, 1]]           # L
];

impl Tetris.start {
    if not [root --> (`?Board)] {
        next = root ++> Board();
    } else {
        next = [root --> (`?Board)];
    }
    self.current_shape = SHAPES[random.randint(0, len(SHAPES)-1)];
    visit next;
    self.render(here);
}

impl Tetris.tick {
    if here.game_over {
        print("Game Over! Final Score:", here.score);
        disengage;
    }

    if self.valid_position(here, self.row + 1, self.col) {
        self.row += 1;
    } else {
        self.lock_piece(here);
        self.clear_lines(here);
        self.spawn_new_piece(here);
    }
    self.render(here);
    print(give_comment("tick", here.score));
}

impl Tetris.move_left {
    if self.valid_position(here, self.row, self.col - 1) {
        self.col -= 1;
    }
    self.render(here);
    print(give_comment("left", here.score));
}

impl Tetris.move_right {
    if self.valid_position(here, self.row, self.col + 1) {
        self.col += 1;
    }
    self.render(here);
    print(give_comment("right", here.score));
}

impl Tetris.rotate {
    new_shape = [[self.current_shape[y][x] for y in range(len(self.current_shape))]
                  for x in range(len(self.current_shape[0])-1, -1, -1)];
    if self.valid_position(here, self.row, self.col, new_shape):
        self.current_shape = new_shape;
    self.render(here);
    print(give_comment("rotate", here.score));
}

can Tetris.valid_position(b: Board, r: int, c: int, shape: list[list[int]]=None) -> bool {
    s = shape if shape else self.current_shape;
    for i in range(len(s)):
        for j in range(len(s[0])):
            if s[i][j] == 1:
                nr = r + i;
                nc = c + j;
                if nr >= 20 or nc < 0 or nc >= 10:
                    return False;
                if b.grid[nr][nc] == 1:
                    return False;
    return True;
}

can Tetris.lock_piece(b: Board) {
    for i in range(len(self.current_shape)):
        for j in range(len(self.current_shape[0])):
            if self.current_shape[i][j] == 1:
                b.grid[self.row+i][self.col+j] = 1;
    if self.row == 0:
        b.game_over = True;
}

can Tetris.clear_lines(b: Board) {
    new_grid = [];
    cleared = 0;
    for row in b.grid:
        if all(cell == 1 for cell in row):
            cleared += 1;
        else:
            new_grid.append(row);
    while len(new_grid) < 20:
        new_grid.insert(0, [0 for _ in range(10)]);
    b.grid = new_grid;
    b.score += cleared * 100;
}

can Tetris.spawn_new_piece(b: Board) {
    self.row = 0;
    self.col = 3;
    self.current_shape = SHAPES[random.randint(0, len(SHAPES)-1)];
    if not self.valid_position(b, self.row, self.col):
        b.game_over = True;
}

can Tetris.render(b: Board) {
    temp = [row[:] for row in b.grid];
    for i in range(len(self.current_shape)):
        for j in range(len(self.current_shape[0])):
            if self.current_shape[i][j] == 1:
                if self.row+i < 20 and self.col+j < 10:
                    temp[self.row+i][self.col+j] = 1;

    print("\n" + "="*22);
    for row in temp:
        print("".join(["[]" if x == 1 else "  " for x in row]));
    print("="*22);
    print("Score:", b.score);
}
