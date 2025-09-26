import json

def add_is_learned_attribute_inplace(filename):
    try:

        with open(filename, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        for item in data:
            item['is_learned'] = False
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        
    except FileNotFoundError:
        print(f"Ошибка: Файл {filename} не найден")
    except json.JSONDecodeError:
        print("Ошибка: Неверный формат JSON файла")
    except Exception as e:
        print(f"Произошла ошибка: {e}")

if __name__ == "__main__":
    filename = "words.json"  
    add_is_learned_attribute_inplace(filename)