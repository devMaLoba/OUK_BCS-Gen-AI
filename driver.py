import sys
import subprocess
import platform

# Detect OS for key input
if platform.system() == "Windows":
    import msvcrt
    def get_key():
        ch = msvcrt.getch()
        if ch in [b'H', b'P', b'K', b'M']:  # Arrow keys
            return ch
        return None
else:
    import tty, termios
    def get_key():
        fd = sys.stdin.fileno()
        old = termios.tcgetattr(fd)
        try:
            tty.setraw(fd)
            ch = sys.stdin.read(1)
            if ch == '\x1b':  # Escape sequence
                seq = sys.stdin.read(2)
                return seq
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old)
        return None

def call_jac(action):
    """Call Jac walker via subprocess (Jac 0.8.7 syntax)"""
    cmd =[
        "jac", "run",
        "tetris.jac",
        "tetris.impl.jac",
        "-walk", f"Tetris.{action}"
    ]
    print(">>> Running:", "".join(cmd))
    subprocess.run(cmd)
    

def main():
    print("Tetris started. Use arrow keys to play. ESC to quit.")
    while True:
        key = get_key()
        if not key:
            continue
        if platform.system() == "Windows":
            if key == b'K':   # Left
                call_jac("move_left")
            elif key == b'M': # Right
                call_jac("move_right")
            elif key == b'P': # Down
                call_jac("tick")
            elif key == b'H': # Up
                call_jac("rotate")
            elif key == b'\x1b': # ESC
                break
        else:
            if key == "[D":  # Left
                call_jac("move_left")
            elif key == "[C": # Right
                call_jac("move_right")
            elif key == "[B": # Down
                call_jac("tick")
            elif key == "[A": # Up
                call_jac("rotate")
            elif key == "":   # ESC
                break

if __name__ == "__main__":
    main()
