class Packet;

  rand byte payload[];
  rand int unsigned len;

  constraint c_len { len inside {[4:8]}; }
  constraint c_size { payload.size() == len; }

  covergroup cg;
    coverpoint len {
      bins l4 = {4};
      bins l5 = {5};
      bins l6 = {6};
      bins l7 = {7};
      bins l8 = {8};
    }
  endgroup

  function new();
    cg = new();
  endfunction

  function void post_randomize();
    cg.sample();
  endfunction

endclass
