PGDMP                     
    {            GYM    15.4    15.4 `    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    25608    GYM    DATABASE     �   CREATE DATABASE "GYM" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "GYM";
                postgres    false            �            1255    25609    check_class_member_limit()    FUNCTION     �  CREATE FUNCTION public.check_class_member_limit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check the number of members already enrolled in the class
    IF (SELECT COUNT(*) FROM public."Enrolls" WHERE e_class_id_fk = NEW.e_class_id_fk) >= 20 THEN
        -- If the limit is reached, raise an error and prevent the insert
        RAISE EXCEPTION 'This class has reached its limit of 20 members.';
    END IF;
    -- If the limit is not reached, allow the insert
    RETURN NEW;
END;
$$;
 1   DROP FUNCTION public.check_class_member_limit();
       public          postgres    false            �            1255    25610    check_trainer_assignment()    FUNCTION     -  CREATE FUNCTION public.check_trainer_assignment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    assigned_members_count INTEGER;
BEGIN
    -- Count the number of members assigned to the trainer
    SELECT COUNT(*) INTO assigned_members_count
    FROM "Assigned to"
    WHERE a_t_id_fk = NEW.a_t_id_fk;

    -- Check if the trainer is being assigned to more than 8 members
    IF assigned_members_count >= 8 THEN
        RAISE EXCEPTION 'Trainer cannot be assigned to more than 8 members at the same time.';
    END IF;

    RETURN NEW;
END;
$$;
 1   DROP FUNCTION public.check_trainer_assignment();
       public          postgres    false            �            1259    25611    Assigned to    TABLE     z   CREATE TABLE public."Assigned to" (
    a_m_id_fk integer NOT NULL,
    a_t_id_fk integer NOT NULL,
    a_cost integer
);
 !   DROP TABLE public."Assigned to";
       public         heap    postgres    false            �            1259    25614    Buys    TABLE     �   CREATE TABLE public."Buys" (
    b_m_id_fk integer NOT NULL,
    barcode_fk integer NOT NULL,
    quantity integer,
    purshase_date date
);
    DROP TABLE public."Buys";
       public         heap    postgres    false            �            1259    25617    Class    TABLE     G  CREATE TABLE public."Class" (
    class_id integer NOT NULL,
    class_t_id_fk integer NOT NULL,
    class_name text NOT NULL,
    class_date date NOT NULL,
    class_start_time time without time zone NOT NULL,
    class_end_time time without time zone NOT NULL,
    g_start_date date NOT NULL,
    g_end_date date NOT NULL
);
    DROP TABLE public."Class";
       public         heap    postgres    false            �            1259    25622    Cleaning Company    TABLE     p   CREATE TABLE public."Cleaning Company" (
    cc_id integer NOT NULL,
    cc_phone_num text,
    cc_name text
);
 &   DROP TABLE public."Cleaning Company";
       public         heap    postgres    false            �            1259    25627    Cleans    TABLE     �   CREATE TABLE public."Cleans" (
    cc_id_fk integer NOT NULL,
    r_id_fk integer NOT NULL,
    cleaning_cost numeric(10,2) NOT NULL,
    cleaning_date date NOT NULL
);
    DROP TABLE public."Cleans";
       public         heap    postgres    false            �            1259    25630    Defect    TABLE     �   CREATE TABLE public."Defect" (
    e_id_fk integer NOT NULL,
    defect_num integer NOT NULL,
    f_mc_id_fk integer,
    defect_description text,
    defect_date date,
    f_cost integer,
    f_status text,
    f_fixing_date date
);
    DROP TABLE public."Defect";
       public         heap    postgres    false            �            1259    25635    Enrolls    TABLE     �   CREATE TABLE public."Enrolls" (
    e_m_id_fk integer NOT NULL,
    e_class_id_fk integer NOT NULL,
    e_cost numeric(10,2)
);
    DROP TABLE public."Enrolls";
       public         heap    postgres    false            �            1259    25638 	   Equipment    TABLE     �   CREATE TABLE public."Equipment" (
    e_id integer NOT NULL,
    e_name text,
    e_purchase_date date,
    company_phone_num text,
    company_name text
);
    DROP TABLE public."Equipment";
       public         heap    postgres    false            �            1259    25643    Feedback    TABLE     �   CREATE TABLE public."Feedback" (
    feedback_id integer NOT NULL,
    f_m_id_fk integer,
    feedback_text text NOT NULL,
    feedback_date date NOT NULL,
    resolution_status text
);
    DROP TABLE public."Feedback";
       public         heap    postgres    false            �            1259    25648    Guest    TABLE     �   CREATE TABLE public."Guest" (
    m_id_fk integer NOT NULL,
    g_name text NOT NULL,
    g_dob date,
    g_gender text,
    g_relationship text
);
    DROP TABLE public."Guest";
       public         heap    postgres    false            �            1259    25653    Maintenance Company    TABLE     s   CREATE TABLE public."Maintenance Company" (
    mc_id integer NOT NULL,
    mc_phone_num text,
    mc_name text
);
 )   DROP TABLE public."Maintenance Company";
       public         heap    postgres    false            �            1259    25658    Member    TABLE     �   CREATE TABLE public."Member" (
    m_id integer NOT NULL,
    m_phone_num text,
    m_email text,
    m_name text,
    m_gender text,
    m_locker_num integer,
    m_dob date,
    m_state text,
    m_city text,
    m_street text
);
    DROP TABLE public."Member";
       public         heap    postgres    false            �            1259    25663    Member Emergency Contact    TABLE     o   CREATE TABLE public."Member Emergency Contact" (
    m_id_fk integer NOT NULL,
    em_contact text NOT NULL
);
 .   DROP TABLE public."Member Emergency Contact";
       public         heap    postgres    false            �            1259    25668 
   Membership    TABLE     u   CREATE TABLE public."Membership" (
    mp_name text NOT NULL,
    mp_price numeric(10,2),
    mp_duration integer
);
     DROP TABLE public."Membership";
       public         heap    postgres    false            �            1259    25673    Product    TABLE     �   CREATE TABLE public."Product" (
    barcode integer NOT NULL,
    p_type text,
    p_name text,
    p_price numeric(10,2),
    p_quantity integer
);
    DROP TABLE public."Product";
       public         heap    postgres    false            �            1259    25678    Require    TABLE     j   CREATE TABLE public."Require" (
    req_class_id_fk integer NOT NULL,
    req_e_id_fk integer NOT NULL
);
    DROP TABLE public."Require";
       public         heap    postgres    false            �            1259    25681    Room    TABLE     R   CREATE TABLE public."Room" (
    r_id integer NOT NULL,
    r_capacity integer
);
    DROP TABLE public."Room";
       public         heap    postgres    false            �            1259    25684    RoomsCleanedByCompany    VIEW       CREATE VIEW public."RoomsCleanedByCompany" AS
 SELECT cl.r_id_fk AS room_id,
    cl.cleaning_cost,
    cc.cc_id AS cleaning_company_id,
    cc.cc_name AS cleaning_company_name
   FROM (public."Cleans" cl
     LEFT JOIN public."Cleaning Company" cc ON ((cl.cc_id_fk = cc.cc_id)));
 *   DROP VIEW public."RoomsCleanedByCompany";
       public          postgres    false    218    217    218    218    217            �            1259    25688    Subscribe to    TABLE     �   CREATE TABLE public."Subscribe to" (
    s_m_id_fk integer NOT NULL,
    mp_name_fk text NOT NULL,
    end_date date,
    start_date date,
    payment_status text
);
 "   DROP TABLE public."Subscribe to";
       public         heap    postgres    false            �            1259    25693    Takes Place In    TABLE     �   CREATE TABLE public."Takes Place In" (
    tp_class_id_fk integer NOT NULL,
    tp_class_name_fk text NOT NULL,
    tp_date date NOT NULL,
    tp_time time without time zone NOT NULL
);
 $   DROP TABLE public."Takes Place In";
       public         heap    postgres    false            �            1259    25698    TotalCleaningCostPerCompany    VIEW     :  CREATE VIEW public."TotalCleaningCostPerCompany" AS
 SELECT cc.cc_id AS cleaning_company_id,
    cc.cc_name AS cleaning_company_name,
    sum(cl.cleaning_cost) AS total_cleaning_cost
   FROM (public."Cleaning Company" cc
     JOIN public."Cleans" cl ON ((cc.cc_id = cl.cc_id_fk)))
  GROUP BY cc.cc_id, cc.cc_name;
 0   DROP VIEW public."TotalCleaningCostPerCompany";
       public          postgres    false    217    218    218    217            �            1259    25702    Trainer    TABLE     �   CREATE TABLE public."Trainer" (
    t_id integer NOT NULL,
    t_name text,
    t_phone_num text,
    t_email text,
    t_dob date,
    t_salary integer
);
    DROP TABLE public."Trainer";
       public         heap    postgres    false            �            1259    34064    enrolled_members_view    VIEW     �   CREATE VIEW public.enrolled_members_view AS
 SELECT m.m_id,
    m.m_name,
    c.class_name
   FROM ((public."Member" m
     JOIN public."Enrolls" e ON ((m.m_id = e.e_m_id_fk)))
     JOIN public."Class" c ON ((e.e_class_id_fk = c.class_id)));
 (   DROP VIEW public.enrolled_members_view;
       public          postgres    false    220    225    225    220    216    216            �            1259    34068    purchasing_members_view    VIEW     �   CREATE VIEW public.purchasing_members_view AS
 SELECT m.m_id,
    m.m_name,
    p.p_name,
    p.p_price
   FROM ((public."Member" m
     JOIN public."Buys" b ON ((m.m_id = b.b_m_id_fk)))
     JOIN public."Product" p ON ((b.barcode_fk = p.barcode)));
 *   DROP VIEW public.purchasing_members_view;
       public          postgres    false    228    225    215    215    225    228    228            �          0    25611    Assigned to 
   TABLE DATA           E   COPY public."Assigned to" (a_m_id_fk, a_t_id_fk, a_cost) FROM stdin;
    public          postgres    false    214   B~       �          0    25614    Buys 
   TABLE DATA           P   COPY public."Buys" (b_m_id_fk, barcode_fk, quantity, purshase_date) FROM stdin;
    public          postgres    false    215   �~       �          0    25617    Class 
   TABLE DATA           �   COPY public."Class" (class_id, class_t_id_fk, class_name, class_date, class_start_time, class_end_time, g_start_date, g_end_date) FROM stdin;
    public          postgres    false    216          �          0    25622    Cleaning Company 
   TABLE DATA           J   COPY public."Cleaning Company" (cc_id, cc_phone_num, cc_name) FROM stdin;
    public          postgres    false    217   �       �          0    25627    Cleans 
   TABLE DATA           S   COPY public."Cleans" (cc_id_fk, r_id_fk, cleaning_cost, cleaning_date) FROM stdin;
    public          postgres    false    218   ��       �          0    25630    Defect 
   TABLE DATA           �   COPY public."Defect" (e_id_fk, defect_num, f_mc_id_fk, defect_description, defect_date, f_cost, f_status, f_fixing_date) FROM stdin;
    public          postgres    false    219   +�       �          0    25635    Enrolls 
   TABLE DATA           E   COPY public."Enrolls" (e_m_id_fk, e_class_id_fk, e_cost) FROM stdin;
    public          postgres    false    220   ��       �          0    25638 	   Equipment 
   TABLE DATA           e   COPY public."Equipment" (e_id, e_name, e_purchase_date, company_phone_num, company_name) FROM stdin;
    public          postgres    false    221   ܂       �          0    25643    Feedback 
   TABLE DATA           m   COPY public."Feedback" (feedback_id, f_m_id_fk, feedback_text, feedback_date, resolution_status) FROM stdin;
    public          postgres    false    222   �       �          0    25648    Guest 
   TABLE DATA           S   COPY public."Guest" (m_id_fk, g_name, g_dob, g_gender, g_relationship) FROM stdin;
    public          postgres    false    223   �       �          0    25653    Maintenance Company 
   TABLE DATA           M   COPY public."Maintenance Company" (mc_id, mc_phone_num, mc_name) FROM stdin;
    public          postgres    false    224   Ѕ       �          0    25658    Member 
   TABLE DATA           �   COPY public."Member" (m_id, m_phone_num, m_email, m_name, m_gender, m_locker_num, m_dob, m_state, m_city, m_street) FROM stdin;
    public          postgres    false    225   {�       �          0    25663    Member Emergency Contact 
   TABLE DATA           I   COPY public."Member Emergency Contact" (m_id_fk, em_contact) FROM stdin;
    public          postgres    false    226    �       �          0    25668 
   Membership 
   TABLE DATA           F   COPY public."Membership" (mp_name, mp_price, mp_duration) FROM stdin;
    public          postgres    false    227   d�       �          0    25673    Product 
   TABLE DATA           Q   COPY public."Product" (barcode, p_type, p_name, p_price, p_quantity) FROM stdin;
    public          postgres    false    228   �       �          0    25678    Require 
   TABLE DATA           A   COPY public."Require" (req_class_id_fk, req_e_id_fk) FROM stdin;
    public          postgres    false    229   �       �          0    25681    Room 
   TABLE DATA           2   COPY public."Room" (r_id, r_capacity) FROM stdin;
    public          postgres    false    230   M�       �          0    25688    Subscribe to 
   TABLE DATA           e   COPY public."Subscribe to" (s_m_id_fk, mp_name_fk, end_date, start_date, payment_status) FROM stdin;
    public          postgres    false    232   ��       �          0    25693    Takes Place In 
   TABLE DATA           ^   COPY public."Takes Place In" (tp_class_id_fk, tp_class_name_fk, tp_date, tp_time) FROM stdin;
    public          postgres    false    233   |�       �          0    25702    Trainer 
   TABLE DATA           X   COPY public."Trainer" (t_id, t_name, t_phone_num, t_email, t_dob, t_salary) FROM stdin;
    public          postgres    false    235   d�       �           2606    25716    Assigned to Assigned to_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."Assigned to"
    ADD CONSTRAINT "Assigned to_pkey" PRIMARY KEY (a_m_id_fk, a_t_id_fk);
 J   ALTER TABLE ONLY public."Assigned to" DROP CONSTRAINT "Assigned to_pkey";
       public            postgres    false    214    214            �           2606    25718    Buys Buys_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public."Buys"
    ADD CONSTRAINT "Buys_pkey" PRIMARY KEY (b_m_id_fk, barcode_fk);
 <   ALTER TABLE ONLY public."Buys" DROP CONSTRAINT "Buys_pkey";
       public            postgres    false    215    215            �           2606    25720    Class Class_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."Class"
    ADD CONSTRAINT "Class_pkey" PRIMARY KEY (class_id);
 >   ALTER TABLE ONLY public."Class" DROP CONSTRAINT "Class_pkey";
       public            postgres    false    216            �           2606    25722 &   Cleaning Company Cleaning Company_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public."Cleaning Company"
    ADD CONSTRAINT "Cleaning Company_pkey" PRIMARY KEY (cc_id);
 T   ALTER TABLE ONLY public."Cleaning Company" DROP CONSTRAINT "Cleaning Company_pkey";
       public            postgres    false    217            �           2606    25724    Cleans Cleans_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public."Cleans"
    ADD CONSTRAINT "Cleans_pkey" PRIMARY KEY (cc_id_fk, r_id_fk);
 @   ALTER TABLE ONLY public."Cleans" DROP CONSTRAINT "Cleans_pkey";
       public            postgres    false    218    218            �           2606    25726    Defect Defect_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."Defect"
    ADD CONSTRAINT "Defect_pkey" PRIMARY KEY (e_id_fk, defect_num);
 @   ALTER TABLE ONLY public."Defect" DROP CONSTRAINT "Defect_pkey";
       public            postgres    false    219    219            �           2606    25728    Enrolls Enrolls_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."Enrolls"
    ADD CONSTRAINT "Enrolls_pkey" PRIMARY KEY (e_m_id_fk, e_class_id_fk);
 B   ALTER TABLE ONLY public."Enrolls" DROP CONSTRAINT "Enrolls_pkey";
       public            postgres    false    220    220            �           2606    25730    Equipment Equipment_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public."Equipment"
    ADD CONSTRAINT "Equipment_pkey" PRIMARY KEY (e_id);
 F   ALTER TABLE ONLY public."Equipment" DROP CONSTRAINT "Equipment_pkey";
       public            postgres    false    221            �           2606    25732    Feedback Feedback_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public."Feedback"
    ADD CONSTRAINT "Feedback_pkey" PRIMARY KEY (feedback_id);
 D   ALTER TABLE ONLY public."Feedback" DROP CONSTRAINT "Feedback_pkey";
       public            postgres    false    222            �           2606    25734    Guest Guest_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."Guest"
    ADD CONSTRAINT "Guest_pkey" PRIMARY KEY (m_id_fk, g_name);
 >   ALTER TABLE ONLY public."Guest" DROP CONSTRAINT "Guest_pkey";
       public            postgres    false    223    223            �           2606    25736 ,   Maintenance Company Maintenance Company_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."Maintenance Company"
    ADD CONSTRAINT "Maintenance Company_pkey" PRIMARY KEY (mc_id);
 Z   ALTER TABLE ONLY public."Maintenance Company" DROP CONSTRAINT "Maintenance Company_pkey";
       public            postgres    false    224            �           2606    25738 6   Member Emergency Contact Member Emergency Contact_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."Member Emergency Contact"
    ADD CONSTRAINT "Member Emergency Contact_pkey" PRIMARY KEY (m_id_fk, em_contact);
 d   ALTER TABLE ONLY public."Member Emergency Contact" DROP CONSTRAINT "Member Emergency Contact_pkey";
       public            postgres    false    226    226            �           2606    25740    Member Member_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public."Member"
    ADD CONSTRAINT "Member_pkey" PRIMARY KEY (m_id);
 @   ALTER TABLE ONLY public."Member" DROP CONSTRAINT "Member_pkey";
       public            postgres    false    225            �           2606    25742    Membership Membership_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public."Membership"
    ADD CONSTRAINT "Membership_pkey" PRIMARY KEY (mp_name);
 H   ALTER TABLE ONLY public."Membership" DROP CONSTRAINT "Membership_pkey";
       public            postgres    false    227            �           2606    25744    Product Product_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_pkey" PRIMARY KEY (barcode);
 B   ALTER TABLE ONLY public."Product" DROP CONSTRAINT "Product_pkey";
       public            postgres    false    228            �           2606    25746    Require Require_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."Require"
    ADD CONSTRAINT "Require_pkey" PRIMARY KEY (req_class_id_fk, req_e_id_fk);
 B   ALTER TABLE ONLY public."Require" DROP CONSTRAINT "Require_pkey";
       public            postgres    false    229    229            �           2606    25748    Room Room_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public."Room"
    ADD CONSTRAINT "Room_pkey" PRIMARY KEY (r_id);
 <   ALTER TABLE ONLY public."Room" DROP CONSTRAINT "Room_pkey";
       public            postgres    false    230            �           2606    25750    Subscribe to Subscribe to_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public."Subscribe to"
    ADD CONSTRAINT "Subscribe to_pkey" PRIMARY KEY (s_m_id_fk, mp_name_fk);
 L   ALTER TABLE ONLY public."Subscribe to" DROP CONSTRAINT "Subscribe to_pkey";
       public            postgres    false    232    232            �           2606    25752    Trainer Trainer_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."Trainer"
    ADD CONSTRAINT "Trainer_pkey" PRIMARY KEY (t_id);
 B   ALTER TABLE ONLY public."Trainer" DROP CONSTRAINT "Trainer_pkey";
       public            postgres    false    235            �           2606    25754    Class unique_class_name 
   CONSTRAINT     Z   ALTER TABLE ONLY public."Class"
    ADD CONSTRAINT unique_class_name UNIQUE (class_name);
 C   ALTER TABLE ONLY public."Class" DROP CONSTRAINT unique_class_name;
       public            postgres    false    216            �           2606    25756    Member unique_m_email 
   CONSTRAINT     U   ALTER TABLE ONLY public."Member"
    ADD CONSTRAINT unique_m_email UNIQUE (m_email);
 A   ALTER TABLE ONLY public."Member" DROP CONSTRAINT unique_m_email;
       public            postgres    false    225            �           2606    25758    Member unique_m_phone_num 
   CONSTRAINT     ]   ALTER TABLE ONLY public."Member"
    ADD CONSTRAINT unique_m_phone_num UNIQUE (m_phone_num);
 E   ALTER TABLE ONLY public."Member" DROP CONSTRAINT unique_m_phone_num;
       public            postgres    false    225            �           2606    25760    Trainer unique_t_email 
   CONSTRAINT     V   ALTER TABLE ONLY public."Trainer"
    ADD CONSTRAINT unique_t_email UNIQUE (t_email);
 B   ALTER TABLE ONLY public."Trainer" DROP CONSTRAINT unique_t_email;
       public            postgres    false    235            �           2606    25762    Trainer unique_t_phone_num 
   CONSTRAINT     ^   ALTER TABLE ONLY public."Trainer"
    ADD CONSTRAINT unique_t_phone_num UNIQUE (t_phone_num);
 F   ALTER TABLE ONLY public."Trainer" DROP CONSTRAINT unique_t_phone_num;
       public            postgres    false    235                       2620    25763 ,   Assigned to check_trainer_assignment_trigger    TRIGGER     �   CREATE TRIGGER check_trainer_assignment_trigger BEFORE INSERT OR UPDATE ON public."Assigned to" FOR EACH ROW EXECUTE FUNCTION public.check_trainer_assignment();
 G   DROP TRIGGER check_trainer_assignment_trigger ON public."Assigned to";
       public          postgres    false    214    239                       2620    25764    Enrolls trg_check_class_limit    TRIGGER     �   CREATE TRIGGER trg_check_class_limit BEFORE INSERT ON public."Enrolls" FOR EACH ROW EXECUTE FUNCTION public.check_class_member_limit();
 8   DROP TRIGGER trg_check_class_limit ON public."Enrolls";
       public          postgres    false    220    238            �           2606    25765 &   Assigned to Assigned to_a_m_id_fk_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Assigned to"
    ADD CONSTRAINT "Assigned to_a_m_id_fk_fkey" FOREIGN KEY (a_m_id_fk) REFERENCES public."Member"(m_id);
 T   ALTER TABLE ONLY public."Assigned to" DROP CONSTRAINT "Assigned to_a_m_id_fk_fkey";
       public          postgres    false    214    225    3291            �           2606    25770 &   Assigned to Assigned to_a_t_id_fk_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Assigned to"
    ADD CONSTRAINT "Assigned to_a_t_id_fk_fkey" FOREIGN KEY (a_t_id_fk) REFERENCES public."Trainer"(t_id);
 T   ALTER TABLE ONLY public."Assigned to" DROP CONSTRAINT "Assigned to_a_t_id_fk_fkey";
       public          postgres    false    235    3309    214            �           2606    25775    Buys Buys_b_m_id_fk_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Buys"
    ADD CONSTRAINT "Buys_b_m_id_fk_fkey" FOREIGN KEY (b_m_id_fk) REFERENCES public."Member"(m_id);
 F   ALTER TABLE ONLY public."Buys" DROP CONSTRAINT "Buys_b_m_id_fk_fkey";
       public          postgres    false    215    225    3291            �           2606    25780    Buys Buys_barcode_fk_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Buys"
    ADD CONSTRAINT "Buys_barcode_fk_fkey" FOREIGN KEY (barcode_fk) REFERENCES public."Product"(barcode);
 G   ALTER TABLE ONLY public."Buys" DROP CONSTRAINT "Buys_barcode_fk_fkey";
       public          postgres    false    228    215    3301            �           2606    25785    Cleans Cleans_cc_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Cleans"
    ADD CONSTRAINT "Cleans_cc_fk" FOREIGN KEY (cc_id_fk) REFERENCES public."Cleaning Company"(cc_id) ON UPDATE CASCADE ON DELETE CASCADE;
 A   ALTER TABLE ONLY public."Cleans" DROP CONSTRAINT "Cleans_cc_fk";
       public          postgres    false    218    3275    217            �           2606    25790    Cleans Cleans_r_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Cleans"
    ADD CONSTRAINT "Cleans_r_fk" FOREIGN KEY (r_id_fk) REFERENCES public."Room"(r_id) ON UPDATE CASCADE ON DELETE CASCADE;
 @   ALTER TABLE ONLY public."Cleans" DROP CONSTRAINT "Cleans_r_fk";
       public          postgres    false    230    218    3305            �           2606    25795    Defect Defect_e_id_fk_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Defect"
    ADD CONSTRAINT "Defect_e_id_fk_fkey" FOREIGN KEY (e_id_fk) REFERENCES public."Equipment"(e_id);
 H   ALTER TABLE ONLY public."Defect" DROP CONSTRAINT "Defect_e_id_fk_fkey";
       public          postgres    false    219    221    3283            �           2606    25800    Defect Defect_f_mc_id_fk_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Defect"
    ADD CONSTRAINT "Defect_f_mc_id_fk_fkey" FOREIGN KEY (f_mc_id_fk) REFERENCES public."Maintenance Company"(mc_id);
 K   ALTER TABLE ONLY public."Defect" DROP CONSTRAINT "Defect_f_mc_id_fk_fkey";
       public          postgres    false    3289    224    219            �           2606    25805    Guest Guest_m_id_fk_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Guest"
    ADD CONSTRAINT "Guest_m_id_fk_fkey" FOREIGN KEY (m_id_fk) REFERENCES public."Member"(m_id);
 F   ALTER TABLE ONLY public."Guest" DROP CONSTRAINT "Guest_m_id_fk_fkey";
       public          postgres    false    225    223    3291            �           2606    25810 >   Member Emergency Contact Member Emergency Contact_m_id_fk_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Member Emergency Contact"
    ADD CONSTRAINT "Member Emergency Contact_m_id_fk_fkey" FOREIGN KEY (m_id_fk) REFERENCES public."Member"(m_id) ON UPDATE CASCADE ON DELETE CASCADE;
 l   ALTER TABLE ONLY public."Member Emergency Contact" DROP CONSTRAINT "Member Emergency Contact_m_id_fk_fkey";
       public          postgres    false    225    226    3291                        2606    25815    Require Require_class_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Require"
    ADD CONSTRAINT "Require_class_fk" FOREIGN KEY (req_class_id_fk) REFERENCES public."Class"(class_id) ON UPDATE CASCADE ON DELETE CASCADE;
 F   ALTER TABLE ONLY public."Require" DROP CONSTRAINT "Require_class_fk";
       public          postgres    false    229    3271    216                       2606    25820    Require Require_equip_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Require"
    ADD CONSTRAINT "Require_equip_fk" FOREIGN KEY (req_e_id_fk) REFERENCES public."Equipment"(e_id) ON UPDATE CASCADE ON DELETE CASCADE;
 F   ALTER TABLE ONLY public."Require" DROP CONSTRAINT "Require_equip_fk";
       public          postgres    false    221    229    3283                       2606    25825 )   Subscribe to Subscribe to_mp_name_fk_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Subscribe to"
    ADD CONSTRAINT "Subscribe to_mp_name_fk_fkey" FOREIGN KEY (mp_name_fk) REFERENCES public."Membership"(mp_name);
 W   ALTER TABLE ONLY public."Subscribe to" DROP CONSTRAINT "Subscribe to_mp_name_fk_fkey";
       public          postgres    false    3299    227    232                       2606    25830 (   Subscribe to Subscribe to_s_m_id_fk_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Subscribe to"
    ADD CONSTRAINT "Subscribe to_s_m_id_fk_fkey" FOREIGN KEY (s_m_id_fk) REFERENCES public."Member"(m_id);
 V   ALTER TABLE ONLY public."Subscribe to" DROP CONSTRAINT "Subscribe to_s_m_id_fk_fkey";
       public          postgres    false    232    3291    225            �           2606    25835    Class class_t_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Class"
    ADD CONSTRAINT class_t_id_fk FOREIGN KEY (class_t_id_fk) REFERENCES public."Trainer"(t_id) ON UPDATE CASCADE ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public."Class" DROP CONSTRAINT class_t_id_fk;
       public          postgres    false    216    235    3309            �           2606    25840    Enrolls e_class_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Enrolls"
    ADD CONSTRAINT e_class_id_fk FOREIGN KEY (e_class_id_fk) REFERENCES public."Class"(class_id) ON UPDATE CASCADE ON DELETE CASCADE;
 A   ALTER TABLE ONLY public."Enrolls" DROP CONSTRAINT e_class_id_fk;
       public          postgres    false    216    220    3271            �           2606    25845    Enrolls e_m_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Enrolls"
    ADD CONSTRAINT e_m_id_fk FOREIGN KEY (e_m_id_fk) REFERENCES public."Member"(m_id) ON UPDATE CASCADE ON DELETE CASCADE;
 =   ALTER TABLE ONLY public."Enrolls" DROP CONSTRAINT e_m_id_fk;
       public          postgres    false    220    225    3291            �           2606    25850    Feedback f_m_id_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."Feedback"
    ADD CONSTRAINT f_m_id_fk FOREIGN KEY (f_m_id_fk) REFERENCES public."Member"(m_id) NOT VALID;
 >   ALTER TABLE ONLY public."Feedback" DROP CONSTRAINT f_m_id_fk;
       public          postgres    false    225    3291    222                       2606    25855    Takes Place In fk_class_id    FK CONSTRAINT     �   ALTER TABLE ONLY public."Takes Place In"
    ADD CONSTRAINT fk_class_id FOREIGN KEY (tp_class_id_fk) REFERENCES public."Class"(class_id) ON UPDATE CASCADE ON DELETE CASCADE;
 F   ALTER TABLE ONLY public."Takes Place In" DROP CONSTRAINT fk_class_id;
       public          postgres    false    233    3271    216                       2606    25860    Takes Place In fk_class_name    FK CONSTRAINT     �   ALTER TABLE ONLY public."Takes Place In"
    ADD CONSTRAINT fk_class_name FOREIGN KEY (tp_class_name_fk) REFERENCES public."Class"(class_name) ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public."Takes Place In" DROP CONSTRAINT fk_class_name;
       public          postgres    false    216    233    3273            �   @   x����0��^1�>�z��:H^+�&�C�T�(<j�C�[��g�y��⥷7L�$��2
�      �   _   x�=͹�0���>��^����&Y7s		�TsuC�B�-�IKɶ�0ڐ�64
E�i+MäM�m�2m��������=�#����> >�C�      �     x�}��J�0���S�Fr��Y:"�l��ı�iR���M���A]\hr����jN����Z.����Ŗs������tc	<��5{6������m�w��y�?#F��SZ+}���l���$A������N�c�#J���H�b�k����^�It9 �2�F<�(C��:ˡ�W�� %K�4�ɑ�֘�(���O�6]��@��[������Z�}L
��!���c|��øv�vdA����F�5ڪ5�\=
!�7Q��      �   �   x�%��
�0����a$��is.�P�^
Z��$z�흺��caV "�9�0�4o�nT��5�GNd���\R]�Tô��q�B�c?� ����
��Jd\��9�J�h���K�P�â��e7b!�7m��hq!?y{;c~��4�      �   f   x�M͹�0Cњ�Eu��%�ϑ�� V��P|H8=��Nq8�����ahP��0�%�B��R�DáV21Q�/,亸N}cc��>u#������ |#X      �   M  x�m��N�0E������j7 �� !$6y���%.��g\� �;˞�;�^	RH��<b����y3!7�tBPB�D�Dd�	آ��Ϸ2c�p
֧c� �}�:������J� -`�������J0Mh����5�~�r���t�2��B
��4�?��9�3΃)	�ؒO-XFd
6֚!���������bFJP.����r�s��C�x���ff��T��_��+.��4�>���'馱��mG���yIp	%l�8����!籵+\^�^�e��"��*ne�P��pj�w�UL���UL�������8��V�R��o5Gɽ�1ƾ K��      �   D   x�=̻ !���%��r��q"ݓ,�0B��L&�Z,<�'ZAP]��[E��n6�:b_��}CD~5Py      �     x�5��j�0���+�*���&M-�J��b��$C��U�Eˣa�
�ZT���ɥd\0Q�BJ�Q�hPM�9�𼎷���7,��eN�vQ�a�x_�]�ʻ�fLaA��n ��������z��s�q���@;�).�d�^��ԾrA��(p^m�%������Ԓ	�Ք��,�
>Q��p�W��(
]7�8���p�A�i��A?p�P�:������pt�y5u�����4����q��6Z�m��2/{!��B�����+ᑦ?%I�ҩu      �     x�m��j�0E��_�~@�s�uI�)�t�����WR���+<
�B�s��P��Z���$;�A����7�Eު�DV��o��J=:;v��QҐ�3S�"�O2B�!���d|����~�W�b�]C��5���Hx�\�@���P��5��Ύx��wR� iiѰr��B�ߎ�J�����q��^��U�
�s�@�F�O�ٳR�$ff��萘Kl�ں��{��:l���a��<h���e��EQd��Wf�'/���.˲?����      �   �   x�]�;� k���H\��r�4�	�g���}P�"v������j�';��@�ضymn�/�v�b�t�dP��;��-���A	$�t(D3���B2��P@	����r��V�fd�PA���П�@�B5�ja���+����Hf����{�QY�      �   �   x�5�M�0�s�c�~�G�*;z)[ѱ�ʬ��޴l���o(������{�ǄH�+^�Ԇy@Zkc̖<Ĉ���n��ǅ�9�^?c?Q50.��UO~~5��W�B�,I��M�gt@��h�$�����]�>����4      �   u  x�m��n�0�ϫ��P )Q?�((;)� i�^���RR!����5�H�����p�qh	R%������m<4n[_�n���k`�"{$V�[�B�,K���R��T�մ2b+���m��,�L���hkZ��еsc��"�pk�`�м�\$\	��`Y�c7�!���Y���@߽�~o��3߇�̮I>EN(2�\hx��nغp����a�()�R*�ӛ:~���ΌIeϤNyS�[p�0�.a�L� ����W�m��,���q��X��U�| �kZ i+���e��_�l�F�i�d`�gDnH�|�I�E�eNH���f <1ve7�'�9`dL��Kxw����
�����]q��D�:�]Î����xc���P�(��� w<˒+=2��KRBh/�|�Έ,H�\��8�\bh9��o�p`!��7۶���j��5��%�F:5ל�"%�;Q���a?�+ق�1��!�И}��k�e�~���謏͎��f��]�l�۬�)�
Wۭ�W���
.��l��!$N&�%4]m��nbS�{f����)9��"9�ʄ������_9ڒv��������|IvZb
��KO'�'��kkZv�;L�3����Bl!      �   T   x�=ι !C��bN���c5c���Ĳ��5�\�
z3���'��xVm�t +���57�y�������}�#q? ?y�!}      �   ~   x�5̻
1��z�a��k�m�@��&�S�"cV��]%)|��߬`i ���R�{�[;BC��$0��1����r�LԒsH?`6=�u�9W���T�Y4T�C�<g)
�m�vu`L�����(*      �     x�U��j�0��������6)m1�P
�(�/U,#)4�_I	Iz�>����>,���Z�ƚ5���7S"b�u����ݎ��j��byW�<s���^�VyXk:�U�:BE����'��vT?�:�7�*�1�F����<{'e6�r����S�2�x�w�^S*�1�d�t�1�J��$ޏ^,i�Gh����\tq@&��ՉlώĒC��L4t<�I7gx�G�ȱ�j���!m��y#c�Dx;fљ��w�u^ŵ0�γ,��H|�      �   /   x��I   �����(��:H���'�Ų(7���r� ������      �   4   x����@���&v.z��:����V��.F^n%<�a��*�K9|��
�      �   �   x�U��
�0���_*�$}�UP�
��$Ц[��א�tvC{�ɝ t~x�J*] hh���Z��i��b��BC;�هeL�L!yN����}�;���wbt�_s�)�Q';��C�0������ޅ�Pɐɨ���S��#V1F��й�H�f��%\/-��	���Y㯽jh�uѨ�k�f��%B�B��C��l@�rZҘ��0�N7�Hc�M��_��s�      �   �   x���͊�0���׫�(9��qb���8E�ؤ���wo�h��@��<'§;h1?jf(��	�	Ő�L��
�ժ;��������[�h���^��x'�W_�h������"Ƽu�Ӊ����=:%!��l�Qw�LS
y+śs�^����2Od(N���?^W�ΎU"���{��YIA�WH��~��禲l��|�z�����4��]w      �   =  x�U��n� ����6c��W����V�����N[���K3��fwQ���^���|c�R�%�����cZ����Z���^��^}�Gq��߉I�uG���$J�ʀ)��m�}Hb����5�[-*���w�v�8�t<�¬�֑ p\�j����2i`�ǰ������E��u�AI��d����{L�\6Um1x��J�J
�f��z>N��_Ҝˉ�b8Q\7:T|^0<S�`㿳���C⸮t({�t�� /�g�g�C(�ZW��5�Pv�,��Y��mHqY�x�ӡ�H�x����,k��X5M�=ܛ�     