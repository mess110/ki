class IndifferentHash < Hash
  def []=(key,val)
    key = key.to_sym
    super(key, val)
  end

  def [](*args)
    args[0] = args[0].to_sym
    super(*args)
  end
end
