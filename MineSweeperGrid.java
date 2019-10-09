import java.util.ArrayList;
import java.lang.Math;

public class MineSweeperGrid{
  
  private ArrayList<ArrayList<MineSweeperSpace>> grid;
  
  private int x_size;
  private int y_size;
  
  private boolean gameOver;
  
  private boolean isTesting;
 
  public MineSweeperGrid(int x, int y, boolean isTesting_input){
    grid = new ArrayList<ArrayList<MineSweeperSpace>>();
    for(int i = 0; i<y; i++){
      grid.add(new ArrayList<MineSweeperSpace>());
      for(int j = 0; j<x; j++){
        int rand = (int)(Math.random()*5);
        boolean isBomb = false;
        if (rand == 0)
          isBomb = true;
        grid.get(i).add(new MineSweeperSpace(isBomb));
      }
    }
    
    x_size = x;
    y_size = y;
    gameOver = false;
    isTesting = isTesting_input;
    
    for(int i = 0; i<y; i++){
      for(int j = 0; j<x; j++){
        int count = 0;
        for(int a = -1; a<2; a++){
          for(int b = -1; b<2; b++){
            if(0<=(i+a) && (i+a)<y)
              if(0<=(j+b) && (j+b)<x)
                if(grid.get(i+a).get(j+b).isBomb())
                  count++;
          }
        }
        grid.get(i).get(j).setBombsNearby(count);
      }
    }
  }
  
  public void initialReveal(){
    int flag = 0;
    for(int i = 2*y_size/5; i<y_size+2*y_size/5; i++)
      for(int n = x_size/4; n<3*x_size/4; n++)
      {
        if(!grid.get(i%y_size).get(n).isBomb() && grid.get(i%y_size).get(n).getBombsNearby() == 0 && flag == 0)
        {
          reveal(n, i%y_size);
          flag++;
        }
      }
  }
  
  public void flag(int x, int y, boolean flag){
    if (flag)
      grid.get(y).get(x).setStatus(1);
    else
      grid.get(y).get(x).setStatus(0);
  }
  
  public void reveal(int x, int y){
    grid.get(y).get(x).setStatus(2);
    
    if(grid.get(y).get(x).isBomb())
      gameOver = true;
          
    else if (grid.get(y).get(x).getBombsNearby() == 0)
    {
      for(int a = -1; a<2; a++)
        for (int b = -1; b<2; b++)
        {
          int x1 = b+x;
          int y1 = a+y;
          if(0<=x1 && x1<x_size && 0<=y1 && y1<y_size && grid.get(y1).get(x1).getStatus() == 0)
            reveal(x1, y1);
        }
    }
  }
  
  public void print(){
    for(int i = 0; i<x_size; i++)
      System.out.print(i%10 + " ");
    System.out.println();
    for(int i = 0; i<x_size; i++)
      System.out.print("- ");
    System.out.println();
    for(int i = 0; i<y_size; i++)
    {
      for(int n = 0; n<x_size; n++)
      {
        if (grid.get(i).get(n).getStatus()==2){
          if(grid.get(i).get(n).isBomb())
            System.out.print("! ");
          else
            System.out.print(grid.get(i).get(n).getBombsNearby() + " ");
        }
        else if (grid.get(i).get(n).getStatus()==1)
          System.out.print("F ");
        else if (grid.get(i).get(n).getStatus()==0)
          System.out.print("X ");
      }
      
      System.out.print("- " + (i));
      
      if(isTesting){
        System.out.print("\t ");
        for(int n = 0; n<x_size; n++){
          if(grid.get(i).get(n).isBomb())
            System.out.print("! ");
          else
            System.out.print(grid.get(i).get(n).getBombsNearby() + " ");
        }
      }
      
      System.out.println();
    }
  }
  
  public boolean isGameOver(){
    if(!gameOver){
      gameOver = true;
      for(int i = 0; i<y_size; i++){
        for(int j = 0; j<x_size; j++){
          if(grid.get(i).get(j).getStatus() != 2 && !grid.get(i).get(j).isBomb())
            gameOver = false;
        }
      }
    }
    return gameOver;
  }
}