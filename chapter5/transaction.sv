// transaction class:事务类

//generate the random stimulus,declare the fields as "rand"
class transaction;

    rand bit [1:0] addr;
    rand bit       wr_en;
    rand bit       rd_en;
    rand bit [7:0] wdata;
         bit [7:0] rdata;
         bit [1:0] cnt;

    //either write or read operation will be performed at once,
    // so wr_en or rd_en is generated by 'adding constraint'
    constraint wr_rd_c {
        wr_en != rd_en;
    }

endclass : transaction