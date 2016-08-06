class Dog

  attr_accessor :name, :id, :breed

  def initialize(name:, id: nil, breed:)
    @name = name
    @breed = breed
    @id = id
  end

# helper methods
  def self.new_from_db(row)
    new_dog = Dog.new(id: row[0], name: row[1], breed: row[2])
  end

  def update
   sql = "UPDATE
   dogs
   SET name = ?, breed = ?
   WHERE id = ?"
   DB[:conn].execute(sql, self.name, self.breed, self.id)

  end

#all create tables
  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS
    dogs
    (id INTEGER PRIMARY KEY,
    name TEXT,
    breed TEXT);"
    table = DB[:conn].execute(sql)
  end


  def self.create(name:, breed:)
    new_dog = Dog.new(name: name, breed: breed)
    new_dog.save
  end


#all saves
  def save
    sql = " INSERT INTO dogs
    (name, breed)
    VALUES (?, ?);"
    DB[:conn].execute(sql, self.name, self.breed)

    sql ="SELECT
    id
    FROM
    dogs
    ORDER BY
    id DESC
    LIMIT 1"
    array_of_ids = DB[:conn].execute(sql)

    self.id = array_of_ids[0][0]
    return self
  end


#all find tables
  def self.find_or_create_by(name:, breed:)
      sql = "SELECT * FROM
      dogs
      WHERE
      name = ?
      AND
      breed = ?;"
      array_of_dogs = DB[:conn].execute(sql, name, breed)

      if array_of_dogs.empty?
        new_dog = self.create(name: name, breed: breed)
      else
        self.new_from_db(array_of_dogs[0])
      end
    end


  def self.find_by_id(id)
      sql = "SELECT * FROM
      dogs
      WHERE id = ?;"
      row = DB[:conn].execute(sql, id)
      self.new_from_db(row[0])
  end

  def self.find_by_name(name)

  sql = "SELECT * FROM
  dogs
  WHERE
  name = ?;"
  row = DB[:conn].execute(sql, name)
  self.new_from_db(row[0])

  end



#all drop tables
  def self.drop_table
    sql = " DROP TABLE dogs"
    DB[:conn].execute(sql)
  end
  
end
