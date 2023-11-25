from flask import Flask, request, render_template
import psycopg2
from psycopg2 import Error as PsycopgError

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
    

##########################################################################################################################
#  Complex Queries  
    
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

@app.route("/cq2", methods = ["Get"])
def cq2():

    cq2 = """
    WITH EnrollmentCounts AS (
        SELECT "e_class_id_fk", COUNT(*) AS "EnrollmentCount"
        FROM "Enrolls"
        GROUP BY "e_class_id_fk"
    )
    SELECT "Class"."class_name" AS "ClassName", "EnrollmentCount"
    FROM EnrollmentCounts
    JOIN "Class" ON "Class"."class_id" = EnrollmentCounts."e_class_id_fk";
    """

    cursor.execute(cq2)
    rows = cursor.fetchall() 
      
    if not rows:
        return render_template("cq2.html")
    return render_template("cq2.html", rows=rows)

@app.route("/cq3", methods = ["Get"])
def cq3():

    cq3 = """
    SELECT 
            cc.cc_name AS "Cleaning Company",
            SUM(cl.cleaning_cost) AS "Total Cleaning Cost",
            ROUND(AVG(r.r_capacity), 1) AS "Average Room Capacity"
        FROM "Cleaning Company" cc
        JOIN "Cleans" cl ON cc.cc_id = cl.cc_id_fk
        JOIN "Room" r ON cl.r_id_fk = r.r_id
        GROUP BY cc.cc_name
        ORDER BY "Total Cleaning Cost" DESC;
    """

    cursor.execute(cq3)
    rows = cursor.fetchall() 
        
    if not rows:
        return render_template("cq3.html")
    return render_template("cq3.html", rows=rows)

@app.route("/cq4", methods = ["Get"])
def cq4():

    cq4 = """
    SELECT 
        M.m_id,
        M.m_name,
        M.m_email,
        M.m_city,
        M.m_state,
        SUM(B.quantity * P.p_price) AS total_spent,
        STRING_AGG(P.p_name || ' (x' || B.quantity || ')', ', ') AS products_bought
    FROM public."Member" M
    JOIN public."Buys" B ON M.m_id = B.b_m_id_fk
    JOIN public."Product" P ON B.barcode_fk = P.barcode
    GROUP BY M.m_id
    ORDER BY total_spent DESC;
    """

    cursor.execute(cq4)
    rows = cursor.fetchall()     
        
    if not rows:
        return render_template("cq4.html")  
    return render_template("cq4.html", rows=rows)

@app.route("/cq5", methods = ["Get"])
def cq5():

    cq5 = """
    SELECT m.m_name AS "MemberName", p.p_name AS "BoughtProducts"
            FROM "Member" m
            JOIN "Buys" b ON m.m_id = b.b_m_id_fk
            JOIN "Product" p ON b.barcode_fk = p.barcode
            WHERE EXISTS (
                SELECT feedback_id
                FROM "Feedback" f
                WHERE m.m_id = f.f_m_id_fk
            );
    """

    cursor.execute(cq5)
    rows = cursor.fetchall() 
        
    if not rows:
        return render_template("cq5.html")  
    return render_template("cq5.html", rows=rows)
        
@app.route("/cq6", methods = ["Get"])
def cq6():

    cq6 = """
    SELECT
    m.m_name AS "MemberName",
    (
        SELECT COUNT(DISTINCT e.e_class_id_fk)
        FROM "Enrolls" e
        WHERE e.e_m_id_fk = m.m_id
    ) AS "TotalClassesEnrolled",
    (
        SELECT SUM(b.quantity * p.p_price)
        FROM "Buys" b
        INNER JOIN "Product" p ON b.barcode_fk = p.barcode
        WHERE b.b_m_id_fk = m.m_id
    ) AS "TotalSpentOnProducts",
    (
        SELECT COUNT(*) AS "FeedbackCount"
        FROM "Feedback" f
        WHERE f.f_m_id_fk = m.m_id
        GROUP BY f.f_m_id_fk
    ) AS "FeedbackCount"
    FROM "Member" m;
    """

    cursor.execute(cq6)
    rows = cursor.fetchall() 
        
    if not rows:
        return render_template("cq6.html")   
    return render_template("cq6.html", rows=rows)

@app.route("/cq7", methods = ["Get"])
def cq7():

    cq7 = """
    SELECT m.m_id, m.m_name, 'Enrolled' AS activity_type
    FROM "Member" m
    JOIN "Enrolls" e ON m.m_id = e.e_m_id_fk
    UNION
    SELECT m.m_id, m.m_name, 'Bought' AS activity_type
    FROM "Member" m
    JOIN "Buys" b ON m.m_id = b.b_m_id_fk
    WHERE EXISTS (
    SELECT 1
    FROM "Product" p
    WHERE p.barcode = b.barcode_fk
    AND b.quantity > 5
    )
    ORDER BY m_id;"""

    cursor.execute(cq7)
    rows = cursor.fetchall() 
        
    if not rows:
        return render_template("cq7.html")  
    return render_template("cq7.html", rows=rows)

@app.route("/cq8", methods = ["Get"])
def cq8():

    cq8 = """
    WITH EnrolledMembers AS (
    SELECT m.m_id
    FROM "Member" m
    JOIN "Enrolls" e ON m.m_id = e.e_m_id_fk
    ),
    BoughtMembers AS (
    SELECT m.m_id
    FROM "Member" m
    JOIN "Buys" b ON m.m_id = b.b_m_id_fk
    ),
    AssignedMembers AS (
    SELECT m.m_id AS m_id, m.m_name AS m_name
    FROM "Member" m
    JOIN "Assigned to" a ON m.m_id = a.a_m_id_fk
    JOIN "Trainer" t ON a.a_t_id_fk = t.t_id
    )
    SELECT m.m_id, m.m_name
    FROM "Member" m
    WHERE m.m_id IN (SELECT m_id FROM EnrolledMembers INTERSECT SELECT m_id 
    FROM BoughtMembers)
    EXCEPT
    SELECT m_id, m_name FROM AssignedMembers
    ORDER BY m_id;
    """

    cursor.execute(cq8)
    rows = cursor.fetchall()
    if not rows:
        return render_template("cq8.html")
    return render_template("cq8.html", rows=rows)

@app.route("/cq9", methods = ["Get"])
def cq9():

    cq9 = """
    SELECT t.t_id, t.t_name
    FROM "Trainer" t
    JOIN "Assigned to" a ON t.t_id = a.a_t_id_fk
    -- Trainers with assigned members
    WHERE t.t_id IN (
    SELECT DISTINCT a_t_id_fk
    FROM "Assigned to"
    )
    INTERSECT
    SELECT t.t_id, t.t_name
    FROM "Trainer" t
    JOIN "Assigned to" a ON t.t_id = a.a_t_id_fk
    JOIN "Member" m ON a.a_m_id_fk = m.m_id
    JOIN "Enrolls" e ON m.m_id = e.e_m_id_fk
    GROUP BY t.t_id, t.t_name;
    """

    cursor.execute(cq9)
    rows = cursor.fetchall() 
        
    if not rows:
        return render_template("cq9.html")  
    return render_template("cq9.html", rows=rows)

@app.route("/cq10", methods = ["Get"])
def cq10():

    cq10 = """
    DROP VIEW IF EXISTS enrolled_members_view;
    DROP VIEW IF EXISTS purchasing_members_view;
    CREATE VIEW enrolled_members_view AS
    SELECT m.m_id, m.m_name, c.class_name
    FROM "Member" m
    JOIN "Enrolls" e ON m.m_id = e.e_m_id_fk
    JOIN "Class" c ON e.e_class_id_fk = c.class_id;
    CREATE VIEW purchasing_members_view AS
    SELECT m.m_id, m.m_name, p.p_name, p.p_price
    FROM "Member" m
    JOIN "Buys" b ON m.m_id = b.b_m_id_fk
    JOIN "Product" p ON b.barcode_fk = p.barcode;
    -- Use UNION to combine the results of enrolled members and purchasing members
    WITH combined_activities AS (
    SELECT m_id, m_name, 'Enrollment' AS activity_type, class_name AS activity
    FROM enrolled_members_view
    UNION
    SELECT m_id, m_name, 'Purchase' AS activity_type, p_name AS activity
    FROM purchasing_members_view
    )
    -- Filter for members who have both enrolled in a class and made a purchase
    SELECT m_id, m_name, activity_type, activity
    FROM combined_activities
    WHERE m_id IN (
    SELECT m_id
    FROM combined_activities
    GROUP BY m_id
    HAVING COUNT(DISTINCT activity_type) = 2
    )
    ORDER BY m_id;
    """

    cursor.execute(cq10)
    rows = cursor.fetchall() 
    
    if not rows:
        return render_template("cq10.html")  
    return render_template("cq10.html", rows=rows)


@app.route("/cq11", methods = ["Get"])
def cq11():

    cq11 = """
    SELECT 
    e.e_name AS equipment_name,
    e.e_purchase_date,
    d.defect_description,
    mc.mc_name AS maintenance_company
    FROM "Equipment" e
    JOIN "Defect" d ON e.e_id = d.e_id_fk
    JOIN "Maintenance Company" mc ON d.f_mc_id_fk = mc.mc_id
    WHERE e.e_purchase_date > '2022-01-01';
    """

    cursor.execute(cq11)
    rows = cursor.fetchall() 
        
    if not rows:
        return render_template("cq11.html")  
    return render_template("cq11.html", rows=rows)


@app.route("/cq12", methods = ["Get"])
def cq12():

    cq12 = """
    SELECT 
    M.m_name,
    MS.mp_name AS Membership_Type,
    F.feedback_text,
    F.resolution_status
    FROM public."Member" M
    INNER JOIN public."Subscribe to" S ON M.m_id = S.s_m_id_fk
    INNER JOIN public."Membership" MS ON S.mp_name_fk = MS.mp_name
    INNER JOIN public."Feedback" F ON M.m_id = F.f_m_id_fk
    ORDER BY M.m_id ASC;
    """

    cursor.execute(cq12)
    rows = cursor.fetchall() 
      
    if not rows:
        return render_template("cq12.html")
    return render_template("cq12.html", rows=rows)

##########################################################################################################################
@app.route("/admin")
def admin():
    return render_template("admin.html")

@app.route("/admin/PageAll") 
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

@app.route('/admin/update_trainer_salaries', methods=['GET', 'POST'])
def update_trainer_salaries():
    if request.method == 'POST':
        try:
            with conn.cursor() as cursor:
                # Update trainer salaries by 10%
                cursor.execute("UPDATE \"Trainer\" SET t_salary = t_salary * 1.1;")
                
                # Commit the transaction
                conn.commit()
                
                # Set a flag for successful update
                update_success = True
                return render_template('update_trainer_salaries.html', update_success=update_success)

        except psycopg2.Error as e:
            # Handle database errors
            return render_template('error.html', error_message=f"An unexpected error occurred: {e}")

    return render_template('update_trainer_salaries.html', update_success=False)


@app.route("/admin/BuyingActions")
def BuyingActions():
    return render_template("buying_actions.html")


@app.route("/admin/BuyingActions/AmountSpent", methods=['GET', 'POST'])
def AmountSpent():
    if request.method == 'POST':
        member_id = request.form['mid']

        try:
            # Execute the SQL query to calculate the total amount
            with conn.cursor() as cursor:
                cursor.execute("""
                    SELECT SUM(p.p_price * b.quantity) AS total_amount
                    FROM "Buys" b
                    JOIN "Product" p ON b.barcode_fk = p.barcode
                    WHERE b.b_m_id_fk = %s;
                """, (member_id,))

                result = cursor.fetchone()
                total_amount = result[0] if result else None

            return render_template('amount_spent.html', total_amount=total_amount)

        except PsycopgError as e:
            return render_template('error.html', error_message=f"An unexpected database error occurred: {e}")

    return render_template('amount_spent.html', total_amount=None)


@app.route('/admin/BuyingActions/AddPurchase', methods=['GET', 'POST'])
def AddPurchase():
    if request.method == 'POST':
        member_id = request.form['b_m_id_fk']
        barcode = request.form['barcode_fk']
        quantity = request.form['quantity']
        purchase_date = request.form['purchase_date']

        try:
            # Execute the SQL query to insert into the "Buys" table
            with conn.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO "Buys" (b_m_id_fk, barcode_fk, quantity, purshase_date)
                    VALUES (%s, %s, %s, %s);
                """, (member_id, barcode, quantity, purchase_date))
                
                # Commit the transaction (if you're using connection pooling)
                conn.commit()

            # Render the same template after adding a new purchase
            return render_template('add_purchase.html')

        except PsycopgError as e:
            return render_template('error.html', error_message=f"An unexpected database error occurred: {e}")

    return render_template('add_purchase.html')

@app.route('/admin/BuyingActions/update_product_quantity', methods=['GET', 'POST'])
def update_product_quantity():
    if request.method == 'POST':
        barcode = request.form['barcode']
        new_quantity = request.form['new_quantity']

        try:
            with conn.cursor() as cursor:
                # Execute the SQL query to update the product quantity
                cursor.execute("""
                    UPDATE "Product" SET p_quantity = %s WHERE barcode = %s;
                """, (new_quantity, barcode))

                # Commit the transaction
                conn.commit()

            return render_template('update_product_quantity.html', success=True)

        except Exception as e:
            return render_template('update_product_quantity.html', success=False, error_message=str(e))

    return render_template('update_product_quantity.html', success=None)

if __name__ == '__main__':
    app.run(debug=True)
