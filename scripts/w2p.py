import os, win32com.client, pythoncom

def convert():
    pythoncom.CoInitialize()
    word = win32com.client.Dispatch("Word.Application")
    excel = win32com.client.Dispatch("Excel.Application")
    
    for f in os.listdir('.'):
        path = os.path.abspath(f)
        if f.endswith(('.docx', '.doc')):
            doc = word.Documents.Open(path)
            doc.SaveAs(path.rsplit('.', 1)[0] + ".pdf", FileFormat=17)
            doc.Close()
        elif f.endswith(('.xlsx', '.xls')):
            wb = excel.Workbooks.Open(path)
            wb.ExportAsFixedFormat(0, path.rsplit('.', 1)[0] + ".pdf")
            wb.Close()
            
    word.Quit()
    excel.Quit()
    print("Conversions complete.")

if __name__ == "__main__": convert()