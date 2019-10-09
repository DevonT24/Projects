import java.util.Scanner;

public class MineSweeperRunner{
  public static void main (String[] args){
    Scanner scan = new Scanner(System.in);
    
    boolean isTesting = false;
    int x_size = 20;
    int y_size = 20;
    
    MineSweeperGrid main = new MineSweeperGrid(x_size, y_size, isTesting);
    main.initialReveal();
    
    while(true){
      main.print();
      if(main.isGameOver()){
        System.out.println("Game over.");
        return;
      }
      System.out.println("Enter \"flag\" to flag a space, \"unflag\" to unflag a space, or \"reveal\" to reveal a space.");
      String task = scan.nextLine();
      int x;
      while(true){
        System.out.println("Enter the x coordinate of the space you would like to act on.");
        x = scan.nextInt();
        scan.nextLine();
        if(x < 0 || x >= x_size)
          System.out.println("Invalid coordinate");
        else
          break;
      }
      int y;
      while(true){
        System.out.println("Enter the y coordinate of the space you would like to act on.");
        y = scan.nextInt();
        scan.nextLine();
        if(y < 0 || y >= y_size)
          System.out.println("Invalid coordinate");
        else
          break;
      }
      if(task.equals("flag"))
        main.flag(x,y,true);
      if(task.equals("unflag"))
        main.flag(x,y,false);
      if(task.equals("reveal"))
        main.reveal(x,y);
      
        
    }
  }
}