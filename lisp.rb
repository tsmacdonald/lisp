FUNCTIONS = {
  '+'     => Proc.new { |args| args.reduce(&:+)},
  '*'     => Proc.new { |args| args.reduce(&:*)},
  'if'    => Proc.new { |args| args[0] ? args[1] : args[2] },
  'def'   => Proc.new { |args| VALUES[args[0]] = args[1] },
  'progn' => Proc.new { |args| args.last },
  'let'   => Proc.new { |args| # ["(x 3)(y 4)", "x"]
    old_values = {}
    args[0][1..-2].split.each_slice 2 do |name, val|
      old_values[name] = VALUES[name]
      VALUES[name] = lisp_eval val
    end
    expression = args[1] #'x'
    result = lisp_eval expression
    old_values.each do |name, val|
      VALUES[name] = val
    end
    result
  },
  'defun' => Proc.new { |args|
    fn_name = args[0]
    arglist = args[1][1..-2].split
    body = args[2]
    FUNCTIONS[fn_name] = Proc.new { |inner_args|
      old_values = {}
      inner_args.each_with_index do |argval, i|
        name = arglist[i]
        old_values[name] = VALUES[name]
        VALUES[name] = argval
      end
      result = lisp_eval body
      old_values.each do |name, val|
        VALUES[name] = val
      end
      result
    }
  }
}

VALUES = {}


def lisp_eval raw_expression
  raw_expression = raw_expression.strip.gsub(/\s+/, ' ')
  if integer? raw_expression
    raw_expression.to_i
  elsif boolean? raw_expression
    parse_boolean raw_expression
  elsif VALUES.include? raw_expression
    VALUES[raw_expression]
  elsif symbol? raw_expression
    raw_expression
  else
    primitive_matcher = '([^()]*)'
    first_complex_form_matcher= '(\(.*?\))?'
    rest_matcher= '(.*)'
    token_extractor = Regexp.new(primitive_matcher + first_complex_form_matcher + rest_matcher)

    expr = raw_expression
    if raw_expression.start_with? '('
      expr = raw_expression[1..-1]
    end
    if raw_expression.end_with? ')'
      expr = expr[0..-2]
    end

    match = expr.match token_extractor
    primitives = match[1].split
    first_complex_form = match[2]
    rest = match[3]
    function_name = primitives.shift
    function = FUNCTIONS[function_name]
    unless rest =~ /\(.*\)/
      rest = rest.strip.split
    end
    raw_arglist = (primitives + [first_complex_form] + [rest]).compact.flatten

    if special_form? function_name
      arguments = raw_arglist
    else
      arguments = raw_arglist.map { |e| lisp_eval e }
    end
    result = function.call(arguments)
    result
  end
end

def integer? expr
  expr =~ /^\d+$/
end

def special_form? name
  %w(let defun).include? name
end

def symbol? expr
  expr =~ /^[\-_a-zA-Z0-9!@#\$%\^&*`~]+/
end

def boolean? expr
  expr == "#t" or expr == "#f"
end

def parse_boolean expr
  if expr == "#t"
    true
  elsif expr == "#f"
    false
  else
    raise Exception
  end
end


