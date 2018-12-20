require_relative "../config/environment.rb"

require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def initialize(name, grade, id=nil)
    @name =name
    @grade =grade
    @id =id
  end


  def self.new_from_db(row)
    # create a new Student object given a row from the database
    stt = Student.new(row[1], row[2], row[0])
    #stt.id = row[0]
    #stt.name = row[1]
    #stt.grade = row[2]
    stt
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    #binding.pry
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_9
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 9
    SQL
    #binding.pry
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL
    #binding.pry
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(grade)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL
    #binding.pry
    DB[:conn].execute(sql, grade).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL
    #binding.pry
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(grade)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    #binding.pry
    DB[:conn].execute(sql, grade).map do |row|
      self.new_from_db(row)
    end
  end
  
  def save
    if self.id
      self.update
    else
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name, grade)
    ns = Student.new(name, grade)
    ns.save
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end

