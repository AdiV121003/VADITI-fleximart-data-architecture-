import pandas as pd
import numpy as np
import re
import os
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
from datetime import datetime

# Load environment variables
load_dotenv()

def extract_data():
    """Read all three CSV files with proper parsing"""
    print("Reading CSV files...")
    
    # Read with specific parameters to handle quoted headers
    customers_df = pd.read_csv('customers_raw.csv', quotechar='"', skipinitialspace=True)
    products_df = pd.read_csv('products_raw.csv', quotechar='"', skipinitialspace=True)
    sales_df = pd.read_csv('sales_raw.csv', quotechar='"', skipinitialspace=True)
    
    # Debug: Print columns to verify
    print(f"\nCustomers columns: {customers_df.columns.tolist()}")
    print(f"Products columns: {products_df.columns.tolist()}")
    print(f"Sales columns: {sales_df.columns.tolist()}")
    
    print(f"\n✓ Extracted {len(customers_df)} customers, {len(products_df)} products, {len(sales_df)} sales records")
    
    return customers_df, products_df, sales_df

def transform_customers(df):
    """Transform customers data to match schema"""
    print("\nTransforming customers data...")
    print(f"Original columns: {df.columns.tolist()}")
    
    original_count = len(df)
    
    # Convert customer_id from 'C001' to 1
    def extract_numeric_id(id_value):
        """Extract numeric part from IDs like C001, C002, etc."""
        if pd.isna(id_value):
            return None
        # Remove all non-numeric characters
        numeric_part = re.sub(r'\D', '', str(id_value))
        return int(numeric_part) if numeric_part else None
    
    df['customer_id'] = df['customer_id'].apply(extract_numeric_id)
    
    # Track data quality metrics
    duplicates = df.duplicated(subset=['customer_id']).sum()
    missing_emails = df['email'].isna().sum()
    
    # Remove duplicates
    df = df.drop_duplicates(subset=['customer_id'], keep='first')
    
    # Handle missing emails (drop rows - email is NOT NULL in schema)
    df = df.dropna(subset=['email'])
    
    # Standardize phone formats to +91-XXXXXXXXXX
    def standardize_phone(phone):
        if pd.isna(phone):
            return None
        digits = re.sub(r'\D', '', str(phone))
        if len(digits) == 10:
            return f'+91-{digits}'
        elif len(digits) > 10:
            return f'+91-{digits[-10:]}'
        return phone
    
    df['phone'] = df['phone'].apply(standardize_phone)
    
    # Standardize city names (Title Case)
    if 'city' in df.columns:
        df['city'] = df['city'].str.strip().str.title()
    
    # Handle registration_date
    if 'registration_date' in df.columns:
        df['registration_date'] = pd.to_datetime(df['registration_date'], errors='coerce').dt.strftime('%Y-%m-%d')
    
    # Select and reorder columns to match schema
    df = df[['customer_id', 'first_name', 'last_name', 'email', 'phone', 'city', 'registration_date']]
    
    print(f"✓ Cleaned {len(df)} customers ({duplicates} duplicates removed, {missing_emails} missing emails handled)")
    
    return df, {'original': original_count, 'duplicates': duplicates, 'missing_emails': missing_emails, 'final': len(df)}

def transform_products(df):
    """Transform products data to match schema"""
    print("\nTransforming products data...")
    print(f"Original columns: {df.columns.tolist()}")
    
    original_count = len(df)
    
    # Convert product_id from 'P001' to 1
    def extract_numeric_id(id_value):
        """Extract numeric part from IDs like P001, P002, etc."""
        if pd.isna(id_value):
            return None
        numeric_part = re.sub(r'\D', '', str(id_value))
        return int(numeric_part) if numeric_part else None
    
    df['product_id'] = df['product_id'].apply(extract_numeric_id)
    
    # Track data quality metrics
    duplicates = df.duplicated(subset=['product_id']).sum()
    missing_prices = df['price'].isna().sum()
    missing_stock = df['stock_quantity'].isna().sum()
    
    # Remove duplicates
    df = df.drop_duplicates(subset=['product_id'], keep='first')
    
    # Handle missing prices (drop rows - price is NOT NULL in schema)
    df = df.dropna(subset=['price'])
    
    # Standardize category names (Title Case, strip whitespace)
    df['category'] = df['category'].str.strip().str.title()
    
    # Handle stock values
    df['stock_quantity'] = df['stock_quantity'].fillna(0).astype(int)
    
    # Select and reorder columns to match schema
    df = df[['product_id', 'product_name', 'category', 'price', 'stock_quantity']]
    
    print(f"✓ Cleaned {len(df)} products ({duplicates} duplicates, {missing_prices} missing prices, {missing_stock} missing stock)")
    
    return df, {'original': original_count, 'duplicates': duplicates, 'missing_prices': missing_prices, 'missing_stock': missing_stock, 'final': len(df)}

def transform_sales(df):
    """Transform sales data into orders and order_items tables"""
    print("\nTransforming sales data...")
    print(f"Original columns: {df.columns.tolist()}")
    
    original_count = len(df)
    
    # Convert IDs from 'T001', 'C001', 'P001' to numeric
    def extract_numeric_id(id_value):
        """Extract numeric part from IDs"""
        if pd.isna(id_value):
            return None
        numeric_part = re.sub(r'\D', '', str(id_value))
        return int(numeric_part) if numeric_part else None
    
    df['transaction_id'] = df['transaction_id'].apply(extract_numeric_id)
    df['customer_id'] = df['customer_id'].apply(extract_numeric_id)
    df['product_id'] = df['product_id'].apply(extract_numeric_id)
    
    # Track data quality metrics BEFORE cleaning
    duplicates = df.duplicated(subset=['transaction_id']).sum()
    missing_customer_ids = df['customer_id'].isna().sum()
    missing_product_ids = df['product_id'].isna().sum()
    missing_dates = df['transaction_date'].isna().sum()
        
    print(f"Issues found:")
    print(f"  - Duplicates: {duplicates}")
    print(f"  - Missing customer IDs: {missing_customer_ids}")
    print(f"  - Missing product IDs: {missing_product_ids}")
    print(f"  - Missing dates: {missing_dates}")
    
    # 1. Remove duplicate transactions (keep first occurrence)
    df = df.drop_duplicates(subset=['transaction_id'], keep='first')
    print(f"✓ Removed {duplicates} duplicate transactions")
    
    # 2. Standardize date formats to YYYY-MM-DD
    def standardize_date(date_str):
        """Convert various date formats to YYYY-MM-DD"""
        if pd.isna(date_str):
            return None
        
        # Try different date formats
        date_formats = [
            '%Y-%m-%d',      # 2023-01-15
            '%d/%m/%Y',      # 15/01/2023
            '%m/%d/%Y',      # 01/15/2023
            '%d-%m-%Y',      # 15-01-2023
            '%m-%d-%Y',      # 01-15-2023
            '%Y/%m/%d',      # 2023/01/15
            '%d.%m.%Y',      # 15.01.2023
            '%Y%m%d'         # 20230115
        ]
        
        for fmt in date_formats:
            try:
                return pd.to_datetime(date_str, format=fmt).strftime('%Y-%m-%d')
            except:
                continue
        
        # If none of the formats work, try pandas auto-detection
        try:
            return pd.to_datetime(date_str).strftime('%Y-%m-%d')
        except:
            return None
    
    df['order_date'] = df['transaction_date'].apply(standardize_date)
    print(f"✓ Standardized date formats")
    
    # 3. Drop rows with missing customer_id, product_id, or order_date
    # (These are required for foreign key constraints)
    before_drop = len(df)
    df = df.dropna(subset=['customer_id', 'product_id', 'order_date'])
    dropped = before_drop - len(df)
    print(f"✓ Dropped {dropped} rows with missing critical IDs/dates")
    
    # 4. Calculate subtotal (quantity * unit_price)
    df['subtotal'] = df['quantity'] * df['unit_price']
    
    # 5. Create ORDERS table (one row per transaction)
    # Group by transaction to get total amount per order
    orders_df = df.groupby(['transaction_id', 'customer_id', 'order_date']).agg({
        'subtotal': 'sum',      # Sum all items in the order
        'status': 'first'        # Take the status from the transaction
    }).reset_index()
    
    # Rename columns to match schema
    orders_df.rename(columns={
        'transaction_id': 'order_id',
        'subtotal': 'total_amount'
    }, inplace=True)
    
    # Handle missing status (use default 'Pending')
    orders_df['status'] = orders_df['status'].fillna('Pending')
    
    # Select and reorder columns for orders table
    orders_df = orders_df[['order_id', 'customer_id', 'order_date', 'total_amount', 'status']]
    
    # 6. Create ORDER_ITEMS table (one row per product in each transaction)
    order_items_df = df.copy()
    
    # Rename transaction_id to order_id to match foreign key
    order_items_df.rename(columns={'transaction_id': 'order_id'}, inplace=True)
    
    # Add order_item_id (auto-incrementing primary key)
    order_items_df.insert(0, 'order_item_id', range(1, len(order_items_df) + 1))
    
    # Select and reorder columns for order_items table
    order_items_df = order_items_df[['order_item_id', 'order_id', 'product_id', 'quantity', 'unit_price', 'subtotal']]
    
    # Print summary
    print(f"\n✓ Transformation complete:")
    print(f"  - Created {len(orders_df)} orders")
    print(f"  - Created {len(order_items_df)} order items")
    
    # Prepare metrics for report
    metrics = {
        'original': original_count,
        'duplicates': duplicates,
        'missing_customer_ids': missing_customer_ids,
        'missing_product_ids': missing_product_ids,
        'missing_dates': missing_dates,
        'orders_final': len(orders_df),
        'order_items_final': len(order_items_df)
    }
    
    return orders_df, order_items_df, metrics

def load_to_database(customers_df, products_df, orders_df, order_items_df):
    """Load cleaned data to MySQL database using credentials from .env"""
    
    try:
        # Get credentials from environment variables
        db_user = os.getenv('DB_USER')
        db_password = os.getenv('DB_PASSWORD')
        db_host = os.getenv('DB_HOST')
        db_port = os.getenv('DB_PORT')
        db_name = os.getenv('DB_NAME')
        
        # Create connection string
        connection_string = f'mysql+pymysql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}'
        
        # Create engine
        engine = create_engine(connection_string)
        
        # Test connection
        print("\n" + "="*60)
        print("LOADING DATA TO DATABASE")
        print("="*60)
        print("\nTesting database connection...")
        with engine.connect() as conn:
            print(f"✓ Connected to MySQL database '{db_name}' successfully!")
        
        # Clear existing data (drop tables in correct order)
        print("\nClearing existing tables...")
        with engine.connect() as conn:
            # Disable foreign key checks
            conn.execute(text("SET FOREIGN_KEY_CHECKS = 0"))
            
            # Drop tables in reverse order (child tables first)
            conn.execute(text("DROP TABLE IF EXISTS order_items"))
            conn.execute(text("DROP TABLE IF EXISTS orders"))
            conn.execute(text("DROP TABLE IF EXISTS products"))
            conn.execute(text("DROP TABLE IF EXISTS customers"))
            
            # Re-enable foreign key checks
            conn.execute(text("SET FOREIGN_KEY_CHECKS = 1"))
            
            conn.commit()
        
        print("✓ Existing tables cleared")
        
        # Load customers (now use 'replace' safely)
        print("\nLoading customers table...")
        customers_df.to_sql('customers', engine, if_exists='replace', index=False)
        print(f"✓ Loaded {len(customers_df)} customer records")
        
        # Load products
        print("\nLoading products table...")
        products_df.to_sql('products', engine, if_exists='replace', index=False)
        print(f"✓ Loaded {len(products_df)} product records")
        
        # Load orders
        print("\nLoading orders table...")
        orders_df.to_sql('orders', engine, if_exists='replace', index=False)
        print(f"✓ Loaded {len(orders_df)} order records")
        
        # Load order_items
        print("\nLoading order_items table...")
        order_items_df.to_sql('order_items', engine, if_exists='replace', index=False)
        print(f"✓ Loaded {len(order_items_df)} order item records")
        
        print("\n" + "="*60)
        print("ETL PIPELINE COMPLETED SUCCESSFULLY!")
        print("="*60)
        
        # Close connection
        engine.dispose()
        
        return True
        
    except Exception as e:
        print(f"\n✗ Error occurred during database loading: {e}")
        print("\nPlease check:")
        print("1. .env file exists and has correct credentials")
        print("2. MySQL service is running")
        print("3. Database 'fleximart' exists")
        return False

def generate_data_quality_report(customers_metrics, products_metrics, sales_metrics):
    """Generate comprehensive data quality report"""
    
    report_lines = []
    report_lines.append("="*70)
    report_lines.append("DATA QUALITY REPORT - FLEXIMART ETL PIPELINE")
    report_lines.append("="*70)
    report_lines.append(f"Report Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    report_lines.append("")
    
    # CUSTOMERS
    report_lines.append("-"*70)
    report_lines.append("CUSTOMERS DATA")
    report_lines.append("-"*70)
    report_lines.append(f"Records processed:              {customers_metrics['original']}")
    report_lines.append(f"Duplicates removed:             {customers_metrics['duplicates']}")
    report_lines.append(f"Missing emails handled:         {customers_metrics['missing_emails']}")
    report_lines.append(f"Records loaded successfully:    {customers_metrics['final']}")
    report_lines.append("")
    
    # PRODUCTS
    report_lines.append("-"*70)
    report_lines.append("PRODUCTS DATA")
    report_lines.append("-"*70)
    report_lines.append(f"Records processed:              {products_metrics['original']}")
    report_lines.append(f"Duplicates removed:             {products_metrics['duplicates']}")
    report_lines.append(f"Missing prices handled:         {products_metrics['missing_prices']}")
    report_lines.append(f"Missing stock values handled:   {products_metrics['missing_stock']}")
    report_lines.append(f"Records loaded successfully:    {products_metrics['final']}")
    report_lines.append("")
    
    # SALES/ORDERS
    report_lines.append("-"*70)
    report_lines.append("SALES/ORDERS DATA")
    report_lines.append("-"*70)
    report_lines.append(f"Records processed:              {sales_metrics['original']}")
    report_lines.append(f"Duplicates removed:             {sales_metrics['duplicates']}")
    report_lines.append(f"Missing customer IDs handled:   {sales_metrics['missing_customer_ids']}")
    report_lines.append(f"Missing product IDs handled:    {sales_metrics['missing_product_ids']}")
    report_lines.append(f"Missing dates handled:          {sales_metrics['missing_dates']}")
    report_lines.append(f"Orders filtered (invalid refs): {sales_metrics.get('orders_filtered', 0)}")
    report_lines.append(f"Order items filtered (invalid): {sales_metrics.get('order_items_filtered', 0)}")
    report_lines.append(f"Orders loaded successfully:     {sales_metrics['orders_final']}")
    report_lines.append(f"Order items loaded successfully: {sales_metrics['order_items_final']}")
    report_lines.append("")
    
    # SUMMARY
    total_processed = customers_metrics['original'] + products_metrics['original'] + sales_metrics['original']
    total_loaded = customers_metrics['final'] + products_metrics['final'] + sales_metrics['orders_final'] + sales_metrics['order_items_final']
    total_issues = (customers_metrics['duplicates'] + products_metrics['duplicates'] + 
                   sales_metrics['duplicates'] + customers_metrics['missing_emails'] + 
                   products_metrics['missing_prices'] + sales_metrics.get('orders_filtered', 0) +
                   sales_metrics.get('order_items_filtered', 0))
    
    report_lines.append("="*70)
    report_lines.append("SUMMARY")
    report_lines.append("="*70)
    report_lines.append(f"Total records processed:        {total_processed}")
    report_lines.append(f"Total records loaded to DB:     {total_loaded}")
    report_lines.append(f"Data quality issues resolved:   {total_issues}")
    report_lines.append("="*70)
    
    # Write to file
    report_text = '\n'.join(report_lines)
    with open('data_quality_report.txt', 'w') as f:
        f.write(report_text)
    
    print("\n" + report_text)
    print("\n✓ Data quality report saved to 'data_quality_report.txt'")

def main():
    """Main ETL pipeline execution"""
    print("\n" + "="*70)
    print("FLEXIMART ETL PIPELINE - STARTING")
    print("="*70)
    
    # EXTRACT
    print("\n[1/3] EXTRACT PHASE")
    print("-"*70)
    customers_raw, products_raw, sales_raw = extract_data()
    
    # TRANSFORM
    print("\n[2/3] TRANSFORM PHASE")
    print("-"*70)
    customers_clean, customers_metrics = transform_customers(customers_raw.copy())
    products_clean, products_metrics = transform_products(products_raw.copy())
    orders_clean, order_items_clean, sales_metrics = transform_sales(sales_raw.copy())
    
    # VALIDATE REFERENTIAL INTEGRITY
    print("\n" + "="*70)
    print("VALIDATING REFERENTIAL INTEGRITY")
    print("="*70)
    
    # Get valid customer and product IDs
    valid_customer_ids = set(customers_clean['customer_id'].values)
    valid_product_ids = set(products_clean['product_id'].values)
    
    print(f"Valid customer IDs: {len(valid_customer_ids)}")
    print(f"Valid product IDs: {len(valid_product_ids)}")
    
    # Filter orders to only include valid customer IDs
    orders_before = len(orders_clean)
    orders_clean = orders_clean[orders_clean['customer_id'].isin(valid_customer_ids)]
    orders_filtered = orders_before - len(orders_clean)
    print(f"✓ Filtered {orders_filtered} orders with invalid customer IDs")
    
    # Filter order_items to only include valid order IDs and product IDs
    valid_order_ids = set(orders_clean['order_id'].values)
    order_items_before = len(order_items_clean)
    order_items_clean = order_items_clean[
        (order_items_clean['order_id'].isin(valid_order_ids)) &
        (order_items_clean['product_id'].isin(valid_product_ids))
    ]
    order_items_filtered = order_items_before - len(order_items_clean)
    print(f"✓ Filtered {order_items_filtered} order items with invalid references")
    
    # Convert IDs to integers (remove any float decimals)
    print("\nConverting IDs to integers...")
    customers_clean['customer_id'] = customers_clean['customer_id'].astype(int)
    products_clean['product_id'] = products_clean['product_id'].astype(int)
    orders_clean['customer_id'] = orders_clean['customer_id'].astype(int)
    orders_clean['order_id'] = orders_clean['order_id'].astype(int)
    order_items_clean['order_id'] = order_items_clean['order_id'].astype(int)
    order_items_clean['product_id'] = order_items_clean['product_id'].astype(int)
    order_items_clean['order_item_id'] = order_items_clean['order_item_id'].astype(int)
    print("✓ All IDs converted to integers")
    
    # Update metrics with filtered counts
    sales_metrics['orders_final'] = len(orders_clean)
    sales_metrics['order_items_final'] = len(order_items_clean)
    sales_metrics['orders_filtered'] = orders_filtered
    sales_metrics['order_items_filtered'] = order_items_filtered
    
    # LOAD
    print("\n[3/3] LOAD PHASE")
    print("-"*70)
    success = load_to_database(customers_clean, products_clean, orders_clean, order_items_clean)
    
    if success:
        # GENERATE REPORT
        generate_data_quality_report(customers_metrics, products_metrics, sales_metrics)
    else:
        print("\n✗ ETL Pipeline failed during loading phase")

if __name__ == "__main__":
    main()