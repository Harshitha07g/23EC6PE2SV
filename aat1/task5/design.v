/==============================================
// design.sv
// Exercise 5 : Ethernet Packet
//==============================================

class EthPacket;

  rand byte dest[6];
  rand byte src[6];
  rand byte payload[];
  rand int unsigned length;

  // Length between 46 and 50 (kept small for simulation demo)
  constraint c_len {
    length inside {[46:50]};
  }

  // Payload size must match length
  constraint c_size {
    payload.size() == length;
  }

  // Coverage
  covergroup cg;
    coverpoint length {
      bins l46 = {46};
      bins l47 = {47};
      bins l48 = {48};
      bins l49 = {49};
      bins l50 = {50};
    }
  endgroup

  function new();
    cg = new();
  endfunction

  function void post_randomize();
    cg.sample();
  endfunction

endclass
