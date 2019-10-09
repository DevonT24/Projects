public class MineSweeperSpace{
  
  private int status; //0 is hidden, 1 is marked, 2 is revealed
  
  private boolean isBomb;
  
  private int bombsNearby;
  
  public MineSweeperSpace(boolean isBomb_input){
    isBomb = isBomb_input;
    status = 0;
  }
  
  public void setStatus(int status_input){
    status = status_input;
  }
  
  public void setBombsNearby(int bombsNearby_input){
    bombsNearby = bombsNearby_input;
  }
  
  public int getStatus(){
    return status;
  }
  
  public boolean isBomb(){
    return isBomb;
  }
  
  public int getBombsNearby(){
    return bombsNearby;
  }
}




