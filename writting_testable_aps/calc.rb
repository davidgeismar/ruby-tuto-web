require 'strscan'

# expr    = term expr-op ;
# expr-op = '+' expr
#         | '-' expr
#         | () ;
#
# term    = factor term-op ;
# term-op = '*' term
#         | '/' term
#         | () ;
#
# factor = number
#        | '(' expr ')'
#        | '-' factor ;

class Calc
  class BinaryExpr < Struct.new(:left, :op, :right)
  end

  class UnaryExpr < Struct.new(:op, :node)
  end

  class Atom < Struct.new(:value)
  end

  #

  def evaluate(string)
    tree = _parse(string)
    binding.pry
    _evaluate_tree(tree)
  end

  #

  def _parse(string)
    scanner = StringScanner.new(string)
    _parse_expr(scanner)
  end

  def _parse_expr(scanner)
    left = _parse_term(scanner)
    op, right = _parse_expr_op(scanner)

    if op
      BinaryExpr.new(left, op, right)
    else
      left
    end
  end

  def _parse_expr_op(scanner)
    _eat_space(scanner)
    op = scanner.scan(/[-+]/) || return
    [op, _parse_expr(scanner)]
  end

  def _parse_term(scanner)
    left = _parse_factor(scanner)
    op, right = _parse_term_op(scanner)

    if op
      BinaryExpr.new(left, op, right)
    else
      left
    end
  end

  def _parse_term_op(scanner)
    _eat_space(scanner)
    op = scanner.scan(%r{[\*/]}) || return
    [op, _parse_term(scanner)]
  end

  def _parse_factor(scanner)
    _eat_space(scanner)

    _parse_number(scanner) ||
      _parse_parens(scanner) ||
      _parse_negation(scanner) ||
      raise("can't parse #{scanner.rest}")
  end

  def _parse_number(scanner)
    token = scanner.scan(/[0-9]+(\.[0-9]+)?/) || return
    Atom.new(token.to_f)
  end

  def _parse_parens(scanner)
    scanner.scan(/\(/) || return
    _parse_expr(scanner).tap do
      scanner.scan(/\)/) || raise('unclosed parens')
    end
  end

  def _parse_negation(scanner)
    scanner.scan(/-/) || return
    UnaryExpr.new('-@', _parse_factor(scanner))
  end

  def _eat_space(scanner)
    scanner.scan(/\s+/)
  end

  def _evaluate_tree(node)
    case node
    when UnaryExpr then
      _evaluate_tree(node.node).send(node.op)
    when BinaryExpr then
      _evaluate_tree(node.left).send(node.op, _evaluate_tree(node.right))
    when Atom then
      node.value
    else
      raise "can't evaluate #{node.inspect}"
    end
  end
end
