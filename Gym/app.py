from flask import Flask, request, render_template
import psycopg2

# Connect to the database
conn = psycopg2.connect(
    host="localhost",
    database="GYM",
    user="postgres",
    password="new_password"
)
cursor = conn.cursor()

# Create instance of flask
app = Flask(__name__) 

@app.route("/")
def home(): 
    return render_template("home.html")

@app.route("/trainer")
def trainer():
    return render_template("trainer.html")

@app.route("/trainer/trainer_info", methods = ["Get", "Post"])
def info():
    if request.method == "POST":
        ID = request.form["pid"]
        if ID != "":  
            try:  
                cursor.execute('SELECT t_name, t_phone_num, t_email, t_dob, t_salary FROM "Trainer" WHERE t_id=%s;', (ID,))
                row = cursor.fetchall()
                if row:
                    t_name = row[0][0]
                    t_phone_num = row[0][1]
                    t_email = row[0][2]
                    t_dob = row[0][3]
                    t_salary = row[0][4]
                else:
                    return render_template("error.html", error_message="ID not found")
                 
                return render_template("trainer_info.html", t_name=t_name, t_phone_num=t_phone_num, t_email=t_email, t_dob=t_dob, t_salary=t_salary)
            
            except psycopg2.Error as e:
                return render_template("error.html", error_message=f"An unexpected error occurred: {e}")
        else:
            return render_template("trainer_info.html", t_name = "______", t_phone_num  = "______", t_email = "______" , t_dob= "______",  t_salary = "______")
    else:
        return render_template("trainer_info.html", t_name = "______", t_phone_num  = "______", t_email = "______" , t_dob= "______",  t_salary = "______")
    

@app.route("/trainer/assigned_members", methods = ["Get", "Post"])
def assigned():
    if request.method == "POST":
        ID = request.form["pid"]
        if ID != "":  
            try:  
                cursor.execute('SELECT m_name FROM "Assigned to" JOIN "Member" ON a_m_id_fk = m_id WHERE a_t_id_fk = %s;', (ID,))
                rows = cursor.fetchall()
                if rows:
                    members_list = [row[0] for row in rows]
                else:
                    return render_template("error.html", error_message="ID not found")
                 
                return render_template("assigned_members.html", members_list=members_list)
            
            except psycopg2.Error as e:
                return render_template("error.html", error_message=f"An unexpected error occurred: {e}")
        else:
            return render_template("assigned_members.html", members_list = "______")
    else:
        return render_template("assigned_members.html", members_list = "______")
    

@app.route("/trainer/classes_given", methods = ["Get", "Post"])
def classes_given():
    if request.method == "POST":
        ID = request.form["pid"]
        if ID != "":  
            try:  
                sql="""
                SELECT class_id, class_name, class_date, class_start_time, class_end_time, g_start_date, g_end_date
                FROM "Class" WHERE class_t_id_fk =%s;
                """
                cursor.execute(sql, (ID,))
                rows = cursor.fetchall()
                if not rows:
                    return render_template("error.html", error_message="ID not found")
                 
                return render_template("classes_given.html", rows=rows)
            
            except psycopg2.Error as e:
                return render_template("error.html", error_message=f"An unexpected error occurred: {e}")
        else:
            return render_template("classes_given.html")
    else:
        return render_template("classes_given.html")
    
@app.route("/cq1", methods = ["Get", "Post"])
def cq1():

    cursor.execute('SELECT t_id, t_name	FROM "Trainer";')
    trainers = cursor.fetchall()

    if request.method == "POST":
        t_name= request.form.get('t_name')
        
        cq1="""
        SELECT "Member"."m_name", "Class"."class_name"
        FROM "Member"
        JOIN "Enrolls" ON "Member"."m_id" = "Enrolls"."e_m_id_fk"
        JOIN "Class" ON "Enrolls"."e_class_id_fk" = "Class"."class_id"
        WHERE "Class"."class_t_id_fk" = (
        SELECT "t_id"
        FROM "Trainer"
        WHERE "t_name" = %s);
        """  
    
        cursor.execute(cq1, (t_name,))
        rows = cursor.fetchall()
        if not rows:
            return render_template("error.html", error_message="ID not found")
            
        return render_template("cq1.html", trainers=trainers, rows=rows)
            
    else:
        return render_template("cq1.html", trainers=trainers)
    

    




@app.route("/All") 
def All():
    # "Assigned to" table
    cursor.execute('SELECT * FROM "Assigned to" ORDER BY a_m_id_fk, a_t_id_fk ASC;')
    rows_assigned_to = cursor.fetchall()

    # "Buys" table
    cursor.execute('SELECT * FROM "Buys" ORDER BY b_m_id_fk, barcode_fk ASC;')
    rows_buys = cursor.fetchall()

    # "Class" table
    cursor.execute('SELECT * FROM "Class" ORDER BY class_id ASC;')
    rows_class = cursor.fetchall()

    # "Cleaning Company" table
    cursor.execute('SELECT * FROM "Cleaning Company" ORDER BY cc_id ASC;')
    rows_cleaning_company = cursor.fetchall()

    # "Cleans" table
    cursor.execute('SELECT * FROM "Cleans" ORDER BY cc_id_fk, r_id_fk ASC;')
    rows_cleans = cursor.fetchall()

    # "Defect" table
    cursor.execute('SELECT * FROM "Defect" ORDER BY e_id_fk, defect_num ASC;')
    rows_defect = cursor.fetchall()

    # "Enrolls" table
    cursor.execute('SELECT * FROM "Enrolls" ORDER BY e_m_id_fk, e_class_id_fk ASC;')
    rows_enrolls = cursor.fetchall()

    # "Equipment" table
    cursor.execute('SELECT * FROM "Equipment" ORDER BY e_id ASC;')
    rows_equipment = cursor.fetchall()

    # "Feedback" table
    cursor.execute('SELECT * FROM "Feedback" ORDER BY feedback_id ASC;')
    rows_feedback = cursor.fetchall()

    # "Guest" table
    cursor.execute('SELECT * FROM "Guest" ORDER BY m_id_fk, g_name ASC;')
    rows_guest = cursor.fetchall()

    # "Maintenance Company" table
    cursor.execute('SELECT * FROM "Maintenance Company" ORDER BY mc_id ASC;')
    rows_maintenance_company = cursor.fetchall()

    # "Member" table
    cursor.execute('SELECT * FROM "Member" ORDER BY m_id ASC;')
    rows_member = cursor.fetchall()

    # "Member Emergency Contact" table
    cursor.execute('SELECT * FROM "Member Emergency Contact" ORDER BY m_id_fk, em_contact ASC;')
    rows_emergency_contact = cursor.fetchall()

    # "Membership" table
    cursor.execute('SELECT * FROM "Membership" ORDER BY mp_name ASC;')
    rows_membership = cursor.fetchall()

    # "Product" table
    cursor.execute('SELECT * FROM "Product" ORDER BY barcode ASC;')
    rows_product = cursor.fetchall()

    # "Require" table
    cursor.execute('SELECT * FROM "Require" ORDER BY req_class_id_fk, req_e_id_fk ASC;')
    rows_require = cursor.fetchall()

    # "Room" table
    cursor.execute('SELECT * FROM "Room" ORDER BY r_id ASC;')
    rows_room = cursor.fetchall()

    # "Subscribe to" table
    cursor.execute('SELECT * FROM "Subscribe to" ORDER BY s_m_id_fk, mp_name_fk ASC;')
    rows_subscribe_to = cursor.fetchall()

    # "Takes Place In" table
    cursor.execute('SELECT * FROM "Takes Place In" ORDER BY tp_class_id_fk, tp_class_name_fk, tp_date, tp_time ASC;')
    rows_takes_place_in = cursor.fetchall()

    # "Trainer" table
    cursor.execute('SELECT * FROM "Trainer" ORDER BY t_id ASC;')
    rows_trainer = cursor.fetchall()

    return render_template("PageAll.html", rows_assigned_to=rows_assigned_to, rows_buys=rows_buys, rows_class=rows_class, rows_cleaning_company=rows_cleaning_company, rows_cleans=rows_cleans, rows_defect=rows_defect, rows_enrolls=rows_enrolls, rows_equipment=rows_equipment, rows_feedback=rows_feedback, rows_guest=rows_guest, rows_maintenance_company=rows_maintenance_company, rows_member=rows_member, rows_emergency_contact=rows_emergency_contact, rows_membership=rows_membership, rows_product=rows_product, rows_require=rows_require, rows_room=rows_room, rows_subscribe_to=rows_subscribe_to, rows_takes_place_in=rows_takes_place_in, rows_trainer=rows_trainer)

        

if __name__ == '__main__':
    app.run(debug=True)
