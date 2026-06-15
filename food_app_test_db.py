from urllib.parse import quote_plus
from datetime import date
import sqlite3

# id = 1
# foods = [
#     {"name": "Milk", "expires": date(2026, 5, 1)},
#     {"name": "Bread", "expires": date(2026, 6, 30)},
#     {"name": "Eggs", "expires": date(2026, 6, 15)},
#     {"name": "Chocolate Milk", "expires": date(2026, 5, 20)},
#     {"name": "Milk", "expires": date(2026, 6, 15)},
# ]

# for food in foods:
#     food["id"] = id
#     id += 1

# def add_food():
#     global id
#     name = input("Enter the name of the food or 'cancel' at any time to go back: ")
#     if name.lower() == "cancel":
#         return
#     while True:
#         expires = input("Enter the expiration date (YYYY-MM-DD) or 'cancel' to go back: ")
#         if expires.lower() == "cancel":
#             return
#         try:
#             expires = date.fromisoformat(expires) # convert string to date
#             break
#         except ValueError:
#             print("Invalid date format. Please enter the date in YYYY-MM-DD format.")
#     new_food = {"name": name, "expires": expires, "id": id}
#     id += 1
#     foods.append(new_food)
#     print(f"{name} has been added to the list.")

# def delete_food():
#     while True:
#         delete_food_id = input("Enter the (id of the) food to delete or 'cancel' to go back: ")
#         if delete_food_id.lower() == "cancel":
#             return
#         for food in foods:
#             if str(food["id"]) == delete_food_id:
#                 foods.remove(food)
#                 print(f"{food['name']} has been deleted.")
#                 return
#         print("Food not found. Please enter a valid food ID.")
        
# def display_expired_foods():
    # expired_foods = []
    # for food in foods:
    #     if food["expires"] < today_date:
    #         expired_foods.append(food)
    # print("Expired foods:")
    # for food in expired_foods:
    #     print(f"{food['name']} expired on {food['expires']} (ID: {food['id']})") 
    # print("You should consider throwing these foods away. When you're done, delete them from the list.")
    # print("Do you want to delete any of these foods now? (yes/no)")
    # choice = input()
    # if choice.lower() == "yes":
    #     delete_food()
    # if choice.lower() == "no":
    #     return
        
def display_foods(connection, cursor, today_date):
    cursor.execute("SELECT id, name, expires FROM foods")
    foods = cursor.fetchall() 
    for food in foods:
        message = f"{food["name"]}: "
        food_expires = date.fromisoformat(food["expires"])
        if food_expires < today_date:
            message += f"Expired: {food['expires']} "
        else:             
            message += f"Expires: {food['expires']} "
        message += f"(ID: {food['id']})"
        print(message)
        

# def soon_to_expire():
#     print("Foods expiring within the next 3 days: ")
#     for food in foods:
#         if (food["expires"] - today_date).days <= 3 and food["expires"] >= today_date:
#             print(f"{food['name']} expires on {food['expires']} (ID: {food['id']})")
#     print("Do you want to learn more about any of these foods? (yes/no)")
#     choice = input()
#     if choice.lower() == "yes":
#         find_food_information()
#     if choice.lower() == "no":
#         return

# def find_food_information():
    # while True:
    #     food_id = input("Enter the (id of the) food to find information about or 'cancel' to go back: ")
    #     if food_id.lower() == "cancel":
    #         return
    #     for food in foods:
    #         if str(food["id"]) == food_id: # need to add database functionality to order by name instead of just id
    #             food_name = food["name"]
    #             if food["expires"] < today_date:
    #                 print(f"{food_name} (There is an expired food with this name): ")
    #             elif (food["expires"] - today_date).days <= 3 and food["expires"] >= today_date:
    #                 print(f"{food_name} (There is a soon to expire food with this name): ")
    #             elif (food["expires"] < today_date and (food["expires"] - today_date).days <= 3 and food["expires"] >= today_date):
    #                 print(f"{food_name} (There is an expired and soon to expire food with this name): ")
    #             else:
    #                 print(f"{food_name}: ")       
                
    #             search_food_information_url = (
    #                 "https://www.google.com/search?q="
    #                 + quote_plus(food_name)
    #                 )
    #             search_food_recipes_url = (
    #                 "https://www.google.com/search?q=" # in the future it uses the system's default search engine
    #                 + quote_plus(food_name)
    #                 + "+recipes")
    #             print(f"Search for {food_name} information: {search_food_information_url}")
    #             print(f"Search for {food_name} recipes: {search_food_recipes_url}")
    #             return
    #     print("Food not found. Please enter a valid food ID.")

def setup_database():
    connection = sqlite3.connect("food_app.db")
    connection.row_factory = sqlite3.Row
    cursor = connection.cursor()

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS foods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        expires DATE NOT NULL
    )''')

    connection.commit()
    
    return connection, cursor

def main():
    today_date = date.today() # get today's date
    connection, cursor = setup_database()
    
    print ("Welcome to the Food Expiration Tracker!")
    print("Today's date is:", today_date)
    while True:
        print("What do you want to do?")
        print("1. Display foods")
    #     print("2. Add a food")
    #     print("3. Display expired foods")
    #     print("4. Delete a food")
    #     print("5. Soon to expire foods")
    #     print("6. Food information")
    #     print("7. Exit")
        
        choice = input()
        
        if choice == "1":
            display_foods(connection, cursor, today_date)
    #     elif choice == "2":
    #         add_food()
    #     elif choice == "3":
    #         display_expired_foods()
    #     elif choice == "4":
    #         delete_food()
    #     elif choice == "5":
    #         soon_to_expire()
    #     elif choice == "6":
    #         find_food_information()
    #     elif choice == "7":
    #         print("Goodbye!")
    #         break
            
if __name__ == "__main__":
    main()
