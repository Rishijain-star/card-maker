<?php

namespace App\Support;

/**
 * Static demo data for ID-Shaydi Card Maker admin panel.
 * Replace with API/database when backend is ready.
 */
final class StaticAdminData
{
    public const APP_NAME = 'ID-Shaydi Card Maker';

    public const ADMIN_USERNAME = 'admin';

    public const ADMIN_PASSWORD = 'idshaydi@123';

    public const COMPANY = [
        'name' => 'ID-Shaydi',
        'email' => 'support@idshaydi.com',
        'phone' => '+91 98765 43210',
        'address' => 'Jaipur, Rajasthan, India',
    ];

    /** @return list<array{label: string, route: string, icon: string}> */
    public static function sidebar(): array
    {
        return [
            ['label' => 'Dashboard', 'route' => 'admin.dashboard', 'icon' => 'grid'],
            ['label' => 'Users', 'route' => 'admin.users', 'icon' => 'users'],
            ['label' => 'Products', 'route' => 'admin.products', 'icon' => 'box'],
            ['label' => 'Orders', 'route' => 'admin.orders', 'icon' => 'order'],
            ['label' => 'Leads', 'route' => 'admin.leads', 'icon' => 'lead'],
            ['label' => 'Settings', 'route' => 'admin.settings', 'icon' => 'settings'],
        ];
    }

    /** @return list<array{title: string, value: string, hint: string}> */
    public static function dashboardStats(): array
    {
        $orderStats = self::orderStats();

        return [
            ['title' => 'Total Users', 'value' => (string) count(self::users()), 'hint' => 'All registered users'],
            ['title' => 'Successful Orders', 'value' => (string) $orderStats['successful'], 'hint' => 'Payment completed'],
            ['title' => 'New Leads', 'value' => (string) count(self::leads()), 'hint' => 'Logged in, no order yet'],
            ['title' => 'Revenue', 'value' => '₹'.number_format($orderStats['revenue']), 'hint' => 'From successful orders'],
        ];
    }

    /** @return array{total: int, successful: int, pending: int, revenue: int} */
    public static function orderStats(): array
    {
        $orders = self::orders();
        $successful = array_filter($orders, fn (array $o) => $o['status'] === 'Success');
        $pending = array_filter($orders, fn (array $o) => $o['status'] === 'Pending');
        $revenue = array_sum(array_column(array_values($successful), 'amount'));

        return [
            'total' => count($orders),
            'successful' => count($successful),
            'pending' => count($pending),
            'revenue' => $revenue,
        ];
    }

    /**
     * All platform users — Paid / Unpaid / New.
     *
     * @return list<array{id: int, name: string, email: string, phone: string, payment_status: string, orders_count: int, joined: string}>
     */
    public static function users(): array
    {
        return [
            ['id' => 1, 'name' => 'Karan Jain', 'email' => 'karan@example.com', 'phone' => '9876543210', 'payment_status' => 'Paid', 'orders_count' => 3, 'joined' => '02 Jan 2026'],
            ['id' => 2, 'name' => 'Priya Sharma', 'email' => 'priya@school.com', 'phone' => '9123456780', 'payment_status' => 'Unpaid', 'orders_count' => 1, 'joined' => '15 Jan 2026'],
            ['id' => 3, 'name' => 'Amit Singh', 'email' => 'amit@office.com', 'phone' => '9988776655', 'payment_status' => 'Paid', 'orders_count' => 2, 'joined' => '20 Feb 2026'],
            ['id' => 4, 'name' => 'Sneha Patel', 'email' => 'sneha@gmail.com', 'phone' => '9011223344', 'payment_status' => 'New', 'orders_count' => 0, 'joined' => '05 Jun 2026'],
            ['id' => 5, 'name' => 'Vikram Mehta', 'email' => 'vikram@tcs.com', 'phone' => '8899001122', 'payment_status' => 'Unpaid', 'orders_count' => 1, 'joined' => '28 May 2026'],
            ['id' => 6, 'name' => 'Ananya Reddy', 'email' => 'ananya@school.in', 'phone' => '9090909090', 'payment_status' => 'New', 'orders_count' => 0, 'joined' => '06 Jun 2026'],
            ['id' => 7, 'name' => 'Rahul Verma', 'email' => 'rahul@gmail.com', 'phone' => '9871209871', 'payment_status' => 'Paid', 'orders_count' => 4, 'joined' => '10 Apr 2026'],
            ['id' => 8, 'name' => 'Neha Gupta', 'email' => 'neha@office.com', 'phone' => '8765432109', 'payment_status' => 'New', 'orders_count' => 0, 'joined' => '07 Jun 2026'],
        ];
    }

    /**
     * Logged-in users who have NOT placed any order yet.
     *
     * @return list<array{id: int, name: string, email: string, phone: string, joined: string}>
     */
    public static function leads(): array
    {
        return array_values(array_filter(self::users(), fn (array $u) => $u['orders_count'] === 0));
    }

    /**
     * All orders from the platform.
     *
     * @return list<array{order_id: string, user: string, product: string, qty: int, amount: int, status: string, date: string}>
     */
    public static function orders(): array
    {
        return [
            ['order_id' => 'ORD-1045', 'user' => 'Karan Jain', 'product' => 'ID CARD', 'qty' => 30, 'amount' => 750, 'status' => 'Success', 'date' => '07 Jun 2026'],
            ['order_id' => 'ORD-1044', 'user' => 'Rahul Verma', 'product' => 'LANYARD', 'qty' => 15, 'amount' => 450, 'status' => 'Success', 'date' => '07 Jun 2026'],
            ['order_id' => 'ORD-1043', 'user' => 'Amit Singh', 'product' => 'BADGE', 'qty' => 20, 'amount' => 400, 'status' => 'Success', 'date' => '06 Jun 2026'],
            ['order_id' => 'ORD-1042', 'user' => 'Priya Sharma', 'product' => 'ID CARD', 'qty' => 50, 'amount' => 1250, 'status' => 'Pending', 'date' => '06 Jun 2026'],
            ['order_id' => 'ORD-1041', 'user' => 'Karan Jain', 'product' => 'BELT', 'qty' => 5, 'amount' => 600, 'status' => 'Success', 'date' => '05 Jun 2026'],
            ['order_id' => 'ORD-1040', 'user' => 'Vikram Mehta', 'product' => 'LANYARD', 'qty' => 10, 'amount' => 300, 'status' => 'Pending', 'date' => '04 Jun 2026'],
            ['order_id' => 'ORD-1039', 'user' => 'Rahul Verma', 'product' => 'ID CARD', 'qty' => 40, 'amount' => 1000, 'status' => 'Success', 'date' => '03 Jun 2026'],
            ['order_id' => 'ORD-1038', 'user' => 'Amit Singh', 'product' => 'ID CARD', 'qty' => 25, 'amount' => 625, 'status' => 'Success', 'date' => '02 Jun 2026'],
        ];
    }
}
