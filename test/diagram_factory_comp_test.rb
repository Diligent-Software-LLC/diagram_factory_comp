require_relative 'test_helper'

# DiagramFactoryCompTest.
# @class_description
#   Tests the DiagramFactoryComp class.
class DiagramFactoryCompTest < Minitest::Test

  # Constants.
  CLASS       = DiagramFactory
  TEST_SYMBOL = :test_symbol
  TEST_FLOAT  = 3.14

  # test_conf_doc_f_ex().
  # @description
  #   The .travis.yml, CODE_OF_CONDUCT.md, Gemfile, LICENSE.txt, README.md,
  #   .yardopts, .gitignore, Changelog.md, CODE_OF_CONDUCT.md,
  #   diagram_factory_comp.gemspec, Gemfile.lock, and Rakefile files exist.
  def test_conf_doc_f_ex()
    
    assert_path_exists('.travis.yml')
    assert_path_exists('CODE_OF_CONDUCT.md')
    assert_path_exists('Gemfile')
    assert_path_exists('LICENSE.txt')
    assert_path_exists('README.md')
    assert_path_exists('.yardopts')
    assert_path_exists('.gitignore')
    assert_path_exists('Changelog.md')
    assert_path_exists('CODE_OF_CONDUCT.md')
    assert_path_exists('diagram_factory_comp.gemspec')
    assert_path_exists('Gemfile.lock')
    assert_path_exists('Rakefile')
  
  end

  # test_version_declared().
  # @description
  #   The version was declared.
  def test_version_declared()
    refute_nil(DiagramFactoryComp::VERSION)
  end

  # setup().
  # @description
  #   Set fixtures.
  def setup()
    @node1 = Node.new(nil, TEST_SYMBOL, nil)
    @node2 = Node.new(nil, TEST_FLOAT)
  end

  # DiagramFactory.instance().

  # test_ci_x1().
  # @description
  #   Returns a singleton instance.
  def test_ci_x1()

    singleton = DiagramFactory.instance()
    assert_same(singleton.class(), DiagramFactory)
    second_call_i = DiagramFactory.instance()
    assert_same(singleton, second_call_i)

  end

  # diagram(diagrammable = nil).

  # test_diagram_x1().
  # @description
  #   Any object, excluding Node instances.
  def test_diagram_x1()

    singleton = DiagramFactory.instance()
    assert_raises(ArgumentError) {
      singleton.diagram(TEST_SYMBOL)
    }

  end

  # test_diagram_x2().
  # @description
  #   The diagrammable was more diagrammed.
  def test_diagram_x2()

    singleton = DiagramFactory.instance()
    refute_operator(singleton, 'diagram_exists', @node1)
    diagram = singleton.diagram(@node1)
    assert_operator(singleton, 'diagram_exists', @node1)
    assert_same(diagram.class(), NodeDiagram)

  end

  # test_diagram_x3().
  # @description
  #   The diagrammable's inventory contains diagrams. No diagrammable kind
  #   diagram exists.
  def test_diagram_x3()

    singleton = DiagramFactory.instance()
    diagram1  = singleton.diagram(@node1)
    assert_same(diagram1.class(), NodeDiagram)
    na1 = NodeAdapter.new(@node1)
    na2 = NodeAdapter.new(@node2)
    na1.attach_back(na2)
    na2.attach_front(na1)
    diagram2 = singleton.diagram_update(@node1)
    assert_same(diagram2.class(), NodeDiagram)
    assert_operator(singleton, 'k_diagram_exists', @node1)
    na1.detach_back()
    assert_operator(singleton, 'k_diagram_exists', @node1)

  end

  # test_diagram_x4().
  # @description
  #   The diagrammable's inventory contains diagrams. diagrammable's kind
  #   diagram exists, and is stale.
  def test_diagram_x4()

    singleton = DiagramFactory.instance()
    diagram1  = singleton.diagram(@node1)
    assert_same(diagram1.class(), NodeDiagram)
    diagram1 = singleton.diagram(@node1)
    @node1.data = TEST_FLOAT
    singleton.diagram_update(@node1)
    refute_equal(diagram1, singleton.diagram(@node1))

  end

  # diagram_update(publisher = nil).

  # test_du_x1().
  # @description
  #   A publishable object.
  def test_du_x1()

    singleton = DiagramFactory.instance()
    pre_d     = singleton.diagram(@node1)
    na1 = NodeAdapter.new(@node1)
    na2 = NodeAdapter.new(@node2)
    na1.attach_front(na2)
    post_d = singleton.diagram_update(@node1)
    refute_same(pre_d, post_d)
    assert_same(post_d, singleton.diagram(@node1))

  end

  # test_du_x2().
  # @description
  #   An unpublishable object.
  def test_du_x2()

    singleton = DiagramFactory.instance()
    assert_raises(ArgumentError, "#{TEST_SYMBOL} is not diagrammable.") {
      singleton.diagram_update(TEST_SYMBOL)
    }

  end

  # diagram_exists(diagrammable = nil).

  # test_de_x1().
  # @description
  #   Any instance, excluding Node instances.
  def test_de_x1()

    singleton = DiagramFactory.instance()
    assert_raises(ArgumentError) {
      singleton.diagram(TEST_SYMBOL)
    }
    refute_operator(singleton, 'diagram_exists', TEST_SYMBOL)

  end

  # test_de_x2().
  # @description
  #   A diagrammed Node argument.
  def test_de_x2()

    singleton = DiagramFactory.instance()
    singleton.diagram(@node1)
    assert_operator(singleton, 'diagram_exists', @node1)

  end

  # test_de_x3().
  # @description
  #   An undiagrammed Node.
  def test_de_x3()
    singleton = DiagramFactory.instance()
    refute_operator(singleton, 'diagram_exists', @node1)
  end

  # k_diagram_exists(diagrammable = nil).

  # test_kde_x1().
  # @description
  #   An empty inventory.
  def test_kde_x1()
    singleton = DiagramFactory.instance()
    refute_operator(singleton, 'k_diagram_exists', @node1)
  end

  # test_kde_x2().
  # @description
  #   A diagrammable's kind diagram exists in the Set.
  def test_kde_x2()

    singleton = DiagramFactory.instance()
    singleton.diagram(@node1)
    assert_operator(singleton, 'k_diagram_exists', @node1)

  end

  # test_kde_x3().
  # @description
  #   A diagrammable's kind diagram was never diagrammed. Other kinds were
  #   previously diagrammed.
  def test_kde_x3()

    singleton = DiagramFactory.instance()
    refute_operator(singleton, 'k_diagram_exists', @node1)
    singleton.diagram(@node1)
    na1 = NodeAdapter.new(@node1)
    na2 = NodeAdapter.new(@node2)
    na1.attach_front(na2)
    assert_operator(singleton, 'k_diagram_exists', @node1)

  end

  # test_kde_x4().
  # @description
  #   Any instance, excluding diagrammable instances.
  def test_kde_x4()
    singleton = DiagramFactory.instance()
    refute_operator(singleton, 'k_diagram_exists', TEST_SYMBOL)
  end
  
  # teardown().
  # @description
  #   Cleanup.
  def teardown()
  end
  
end
