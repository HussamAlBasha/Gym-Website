# Gym-Website EECE 433

In pgAdmin4, restore the database by selecting Gym.sql as the restoration file.
Change the following code to connect to the database with the correct credentials:

```python
# Connect to the database
conn = psycopg2.connect(
    host="localhost",
    database="Gym",
    user="your_user_name",
    password="your_password"
)
```
To run the website, navigate to the directory where app.py exists. Run the following command in the terminal: python app.py
Then navigate in your browser to:http://127.0.0.1:5000/ to view the website.
