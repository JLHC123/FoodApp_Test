from datetime import date

id = 1

print("Hello World!")

today_date = date.today() # get today's date
print(f"Today's date is: {today_date}")

foods = [
    {"name": "Milk", "expires": date(2024, 7, 1)},
    {"name": "Bread", "expires": date(2024, 6, 30)},
]

for food in foods:
    food["id"] = id
    id += 1

print(foods)

def add_food():
    name = input("Enter the name of the food or 'cancel' at any time to go back: ")
    if name.lower() == "cancel":
        return
    while True:
        expires = input("Enter the expiration date (YYYY-MM-DD) or 'cancel' to go back: ")
        if expires.lower() == "cancel":
            return
        try:
            expires = date.fromisoformat(expires) # convert string to date
            break
        except ValueError:
            print("Invalid date format. Please enter the date in YYYY-MM-DD format.")
    new_food = {"name": name, "expires": expires, "id": id}
    id += 1
    foods.append(new_food)
    print(f"{name} has been added to the list.")

def delete_food():
    name = input("Enter the name of the food to delete or 'cancel' to go back: ")
    if name.lower() == "cancel":
        return
    

def display_foods():
    for food in foods:
        print(f"{food['name']} expires on {food['expires']}")
        
def display_expired_foods():
    expired_foods = []
    for food in foods:
        if food["expires"] < today_date:
            expired_foods.append(food)
    print("Expired foods:")
    for food in expired_foods:
        print(f"{food['name']} expired on {food['expires']}") 
        
def debug_display_foods():
    for food in foods:
        print(f"ID: {food['id']}, Name: {food['name']}, Expires: {food['expires']}")

def main():
    while True:
        print("What do you want to do?")
        print("0. Debug: Display foods with IDs")
        print("1. Add a food")
        print("2. Display all foods")
        print("3. Display expired foods")
        
        choice = input()
        
        if choice == "0":
            debug_display_foods()
        if choice == "1":
            add_food()
        if choice == "2":
            display_foods()
        if choice == "3":
            display_expired_foods() 

   

if __name__ == "__main__":
    main()
