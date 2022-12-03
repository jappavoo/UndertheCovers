#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define BOARD_ROWS 3
#define BOARD_COLS 3
#define BOARD_START_ROW 0
#define BOARD_START_COL 0
#define BOARD_END_ROW (BOARD_ROWS  - 1)
#define BOARD_END_COL (BOARD_COLS  - 1)
#define BOARD_BLANK_MARKER ' '
#define BOARD_X_MARKER 'X'
#define BOARD_O_MARKER 'O'
#define BOARD_SCAN_DIR_RIGHT 1
#define BOARD_SCAN_DIR_LEFT -1
#define BOARD_SCAN_DIR_NONE 0
#define BOARD_SCAN_DIR_UP -1
#define BOARD_SCAN_DIR_DOWN 1

#define PLAYER_ONE 1
#define PLAYER_TWO 2

#define BAD_MOVE 0
#define NEXT_MOVE 1
#define WIN 2
#define DRAW 3

char Board[BOARD_ROWS][BOARD_COLS] =
  { 
    { BOARD_BLANK_MARKER, BOARD_BLANK_MARKER, BOARD_BLANK_MARKER },
    { BOARD_BLANK_MARKER, BOARD_BLANK_MARKER, BOARD_BLANK_MARKER },
    { BOARD_BLANK_MARKER, BOARD_BLANK_MARKER, BOARD_BLANK_MARKER }
 };

// Board functions
void Board_display(void);
int  Board_num_blanks(void);
bool Board_scan_line_for_marker(int, int, int, int, int, int, char);

// Player functions includes game logic
bool Player_move(int player);
int  Player_validate_move(int player, int r, int c);
bool Player_is_winner(int player);
char Player_marker(int player);

// Misc
void NYI(const char *func_name);

int main(void)
{
  Board_display();
  while (true) {
    if (Player_move(PLAYER_ONE) == true) break;
    Board_display();
    if (Player_move(PLAYER_TWO) == true) break;
    Board_display();
  }
  Board_display();
  return EXIT_SUCCESS;
}

void NYI(const char *func_name)
{
  printf("%s: Not Yet Implemented (NYI)\n", func_name);
  exit(EXIT_FAILURE);
}

void Board_display(void)
{
  int r, c;
  printf("\n");
  for (r=BOARD_START_ROW; r<BOARD_ROWS; r++) {
    for (c=BOARD_START_COL; c<BOARD_COLS; c++) {
      printf(" %c ", Board[r][c]);
      if (c < (BOARD_END_COL)) printf("|");
    }
    if (r < (BOARD_END_ROW)) printf("\n-----------");
    printf("\n");
  }
}

bool Player_move(int player)
{
  int n, r, c, moveResult;
  bool done;

 retry:
  printf("Player %d please enter row,col for your move: ", player);
  n = scanf("%d %d", &r, &c);
  // deal with scanf failures
  if (n == EOF) {
    printf("Ending the Game early... bye.\n");
    return true;
  } else if (n != 2) {
    printf("You must enter two numbers between 0 and 2 inclusively\n");
    while(getchar()!='\n');  // cleanup line as scanf does not 
    goto retry;
  }
  
  moveResult = Player_validate_move(player, r, c);

  switch (moveResult) {
  case BAD_MOVE:
    printf("Try again.\n");
    goto retry;
  case NEXT_MOVE:
    done = false;
    break;
  case WIN: 
    printf("GAME OVER: Player %d WINS!!!\n", player);
    done = true;
    break;
  case DRAW:
    printf("GAME OVER: Draw: No Winner.\n");
    done = true;
    break;
  default:
    printf("INTERNAL ERROR: Bad Move Result %d\n", moveResult);
    exit(EXIT_FAILURE);
  }
  return done;
}

int Player_validate_move(int player, int r, int c)
{
  if (r < BOARD_START_ROW || r > BOARD_END_ROW ||
      c < BOARD_START_COL || c > BOARD_END_COL ||
      Board[r][c] != BOARD_BLANK_MARKER) return BAD_MOVE;

  Board[r][c] = Player_marker(player);

  // check for win 
  if (Player_is_winner(player)==true) return WIN;
  
  // check if there is any blanks left
  if (Board_num_blanks()>0) return NEXT_MOVE;

  // if we get here then board is full and with no winner
  return DRAW;
}

char Player_marker(int player)
{
  if (player != PLAYER_ONE && player != PLAYER_TWO) {
    printf("INTERNAL ERROR: Bad player number: %d\n", player);
    exit(EXIT_FAILURE);
  }
  return (player == PLAYER_ONE) ?  BOARD_X_MARKER : BOARD_O_MARKER;
}

int Board_num_blanks()
{
  int r, c, count=0;

  for (r=BOARD_START_ROW; r<BOARD_ROWS; r++) 
    for (c=BOARD_START_COL; c<BOARD_COLS; c++)
      if (Board[r][c]==BOARD_BLANK_MARKER) count++;

  return count;
}

bool Player_is_winner(int player)
{
  int r, c;
  char m = Player_marker(player);

  // Check to see any row has all its cells matching the player marker 
  for (r=BOARD_START_ROW; r<BOARD_ROWS; r++) {
    if (Board_scan_line_for_marker(r,BOARD_START_COL,
				   r,BOARD_END_COL, 
				   BOARD_SCAN_DIR_RIGHT, BOARD_SCAN_DIR_NONE,
				   m)) return true;
  }
  // Check to see any col has all its cells matching the player marker 
  for (c=BOARD_START_COL; c<BOARD_COLS; c++) {
    if (Board_scan_line_for_marker(BOARD_START_ROW,c,
				   BOARD_END_ROW,c,
				   BOARD_SCAN_DIR_NONE, BOARD_SCAN_DIR_DOWN, 
				   m)) return true;
  }
  // check last upper left to lower right diagonal
  if (Board_scan_line_for_marker(BOARD_START_ROW, BOARD_START_COL,
				 BOARD_END_ROW, BOARD_END_COL,
				 BOARD_SCAN_DIR_RIGHT, BOARD_SCAN_DIR_DOWN, 
				 m)) return true;
  // check last upper right to lower left diagonal
  if (Board_scan_line_for_marker(BOARD_START_ROW, BOARD_END_COL,
				  BOARD_END_ROW, BOARD_START_COL,
				  BOARD_SCAN_DIR_LEFT, BOARD_SCAN_DIR_DOWN,
				  m)) return true;
  return false;
}

bool Board_scan_line_for_marker(int r, int c, int end_row, int end_col, 
				int horizontal_dir, int vertical_dir, char m)
{
  if (r == end_row && c == end_col) return (Board[r][c] == m);
  return (
	  (Board[r][c] == m)  && 
	  Board_scan_line_for_marker(r+vertical_dir, c+horizontal_dir, 
				     end_row, end_col,
				     horizontal_dir, vertical_dir, m));
}
	  
