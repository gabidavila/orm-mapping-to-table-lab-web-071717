class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def save
    sql = <<-SQL
      INSERT INTO students(name, grade) VALUES (?, ?)
    SQL

    DB[:conn].prepare(sql).execute(self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").first.first
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL

    DB[:conn].prepare(sql).execute
  end

  def self.drop_table
    DB[:conn].prepare("DROP TABLE students").execute
  end
end

